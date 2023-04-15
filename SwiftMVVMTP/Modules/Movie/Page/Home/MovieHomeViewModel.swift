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
        let viewWillAppear : Driver<Void>
        let viewDidload : Driver<Void>
        let loadMore : Driver<Int>
        let searchbar : Driver<String>
    }
    struct Event {
        let bookmark : Driver<(IndexPath, Bool)>
    }
    enum Response {
        case none
        case item((HomeModel, isLoadMore: Bool))
        case user(User?)
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
    
    @Storage(key: StorageKey.USER_INFO.rawValue, defaultValue: nil)
    var author : User?
    
    override func transform(input: Input) -> Output {
        
        input.viewDidload.flatMap({[weak self] () -> Driver<Response> in
            guard let _self = self else { return Driver.just(Response.none) }
            return Observable.deferred {() in
                return _self.service.getMovies(.init(page: nil, type: nil)).map({x in
                    return .item((x, false))
                })
            }.trackActivity(_self.activityIndicator)
                .trackError(_self.errorTracker)
                .asDriverOnErrorJustComplete()
        }).do(onNext: {[weak self] data in
            guard let self = self, let d = data.getData() as? ItemType else { return }
            self.itemTemp = d.0
        }).drive(self.$item).disposed(by: self.disposeBag)
            
        input.viewWillAppear.flatMap({[weak self] _ -> Driver<Response> in
            guard let _self = self else { return Driver.just(.none) }
                return Observable.deferred {() ->  Observable<Response> in
                    return Observable.just(.user(_self.author))
            }.trackError(_self.errorTracker)
                .asDriverOnErrorJustComplete()
        }).drive(self.$item)
            .disposed(by: self.disposeBag)
        
        
        input.loadMore.filter({[weak self] _ in
            guard let self = self else { return false }
            return !self.isSearching && !self.isStopLoadMore
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
                    }) {[weak self] _ in
                        guard let self = self else { return }
                        self.isStopLoadMore = true
                    }
                }.trackError(self.errorTracker).asDriverOnErrorJustComplete()
            }).drive(self.$item).disposed(by: self.disposeBag)
                
            input.searchbar.do(onNext: {[weak self] text in
                guard let self = self else { return }
                self.isSearching = !text.isEmpty
            }).flatMap{[weak self] search -> Driver<Response> in
                guard let self = self else { return Driver.just(.none) }
                return Observable.deferred {
                    if(search.isEmpty) { return Observable.just(.item((self.itemTemp, false))) }
                    return self.service.searchMovies(.init(key: search, type: nil)).map({x in
                        return .item((x, false))
                    })
                }.trackError(self.errorTracker)
                    .asDriverOnErrorJustComplete()
            }.drive(self.$item)
            .disposed(by: self.disposeBag)
        return Output(data: self.$item.asDriverOnErrorJustComplete())
    }
    
}
