//
//  MovieHomeViewModel.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 24/09/2021.
//

import Foundation
import RxCocoa
import RxSwift
struct HomeModel {
    var titles : [MovieCategory]
    var datas : [[MovieCollectionViewCellModel]]
}


class MovieHomeViewModel : BaseViewModel<MovieHomeViewModel.Input, MovieHomeViewModel.Output> {
    
    typealias ItemType = (HomeModel, isLoadMore: Bool)
    @Dependency.Inject
    var service : MovieService
    var isSearching = false
    var isStopLoadMore = false {
        didSet {
            print("loading:\(isStopLoadMore)")
        }
    }
    struct Input  {
        let viewWillAppear : Observable<Void>
        let loadMore : Observable<Int>
        let searchbar : Observable<String>
        let event : Event
    }
    struct Event {
        let bookmark : PublishSubject<(IndexPath, Bool)>
    }
    enum Response {
        case none
        case item((HomeModel, isLoadMore: Bool))
        func getData() -> Any? {
            switch self {
            case let .item(value): return value
            default: break
            }
            return nil
        }
    }
    struct Output {
        let data : Driver<Response>
    }
    
    var itemTemp : HomeModel = .init(titles: [], datas: [])
    @BehaviorRelayProperty(value: .none)
    var item : Response
    
    override func transform(input: Input) -> Output {
        input.event.bookmark
        .flatMap({[weak self] itemSelected -> Observable<Response> in
            guard let _self = self, let data = _self.item.getData() as? ItemType  else { return Observable.just(.none) }
            var res = data.0
            res.datas[itemSelected.0.section][itemSelected.0.row].isBookmark = itemSelected.1
//            return Observable.just(.item((res, false)))
            return Observable.just(.none)
        })
        .trackError(self.errorTracker)
        .asDriverOnErrorJustComplete()
        .drive(self.$item)
        .disposed(by: self.disposeBag)
        
        input.viewWillAppear.flatMap({[weak self] _ -> Observable<Response> in
            guard let _self = self else { return Observable.just(.none) }
            return Observable.deferred {() ->  Observable<Response> in
                return _self.service.getMovies(.init(page: nil, type: nil)).map({x in
                    return .item((x, false))
                })
            }.trackActivity(_self.activityIndicator)
                .trackError(_self.errorTracker)
        }).do(onNext: {[weak self] data in
            guard let self = self, let d = data.getData() as? ItemType else { return }
            self.itemTemp = d.0
        }).asDriverOnErrorJustComplete().drive(self.$item).disposed(by: self.disposeBag)
        
        
        input.loadMore.filter({[weak self] _ in
            guard let self = self else { return false }
            return !self.isSearching && !self.isStopLoadMore
        }).do(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.isStopLoadMore = true
        }).flatMap({ section in
            return Observable.deferred { [weak self] () ->  Observable<Response> in
                guard let _self = self, let item = _self.item.getData() as? ItemType else {  return Observable.just(.none) }
                    let page = item.0.titles[section].nextPage
                    print(item.0.titles[section])
                return _self.service.getMoviesByGroup(.init(page: page, type: item.0.titles[section].type)).map({ data in
                        var res = item.0
                        res.titles[section].nextPage = data.page
                        res.datas[section].append(contentsOf: data.data)
                        return .item((res, true))
                    }).do(onNext: {[weak self] data in
                        guard let self = self else { return }
                        let page = item.0.titles[section].nextPage
                        self.isStopLoadMore = page < 0
                    }, onError: {[weak self] err in
                        guard let self = self else { return }
                        self.isStopLoadMore = false
                    })
                }
            }).trackError(self.errorTracker).asDriverOnErrorJustComplete().drive(self.$item).disposed(by: self.disposeBag)
                
            input.searchbar.do(onNext: {[weak self] text in
                guard let self = self else { return }
                self.isSearching = !text.isEmpty
            }).flatMap{[weak self] search -> Observable<Response> in
                guard let self = self else { return Observable.just(.none) }
                if(search.isEmpty) { return Observable.just(.item((self.itemTemp, false))) }
                return self.service.searchMovies(.init(key: search, type: nil)).map({x in
                    return .item((x, false))
                })
            }.trackError(self.errorTracker)
            .asDriverOnErrorJustComplete()
            .drive(self.$item)
            .disposed(by: self.disposeBag)
        return Output(data: self.$item.asDriverOnErrorJustComplete())
    }
    
}
