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
            print("isStopLoadMore:\(isStopLoadMore)")
        }
    }
    var isLoading = false {
        didSet {
            print("isLoading:\(isLoading)")
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

    struct Output {
        let data : Driver<(HomeModel, isLoadMore: Bool)?>
        let user : Driver<User?>
    }
    
    var itemTemp : HomeModel = .init(titles: [], datas: [])
    
    
    @BehaviorRelayProperty(value: nil)
    var item : (HomeModel, isLoadMore: Bool)?
    
    @Storage(key: StorageKey.USER_INFO.rawValue, defaultValue: nil)
    var author : User?
    
    override func transform(input: Input) -> Output {
        
        input.viewDidload.flatMap({[weak self] () -> Driver<(HomeModel, isLoadMore: Bool)?> in
            guard let _self = self else { return Driver.just(nil) }
            return Observable.deferred {() in
                return _self.service.getMovies(.init(page: nil, type: nil)).map({x in
                    return (x, false)
                })
            }.trackActivity(_self.activityIndicator)
                .trackError(_self.errorTracker)
                .asDriverOnErrorJustComplete()
        }).do(onNext: {[weak self] data in
            guard let self = self, let d = data else { return }
            self.itemTemp = d.0
        }).drive(self.$item).disposed(by: self.disposeBag)
            
        let user = input.viewWillAppear.flatMap({[weak self] _ -> Driver<User?> in
            guard let _self = self else { return Driver.just(nil) }
                return Observable.deferred {() ->  Observable<User?> in
                    return Observable.just(_self.author)
            }.trackError(_self.errorTracker)
                .asDriverOnErrorJustComplete()
        })
        
        
        input.loadMore.filter({[weak self] _ in
            guard let self = self else { return false }
            print("isSearching: \(self.isSearching) - isStopLoadMore: \(self.isStopLoadMore) - isLoading: \(self.isLoading)")
            return !self.isSearching && !self.isStopLoadMore && !self.isLoading
        }).flatMap({ section in
            return Observable.deferred { [weak self] () ->  Observable<(HomeModel, isLoadMore: Bool)?> in
                guard let _self = self  else {  return Observable.just(nil) }
                guard let item = _self.item else {  return Observable.just(nil) }
                    let page = item.0.titles[section].nextPage
                print(item.0.titles[section])
                return _self.service.getMoviesByGroup(.init(page: page, type: item.0.titles[section].type)).map({ data in
                        var res = item.0
                        res.titles[section].nextPage = data.page
                        res.datas[section].append(contentsOf: data.data)
                        return (res, true)
                    }).do(onNext: {[weak self] data in
                        guard let self = self else { return }
                        let page = item.0.titles[section].nextPage
                        self.isStopLoadMore = page < 0
                        self.isLoading = false
                    }, onError: {[weak self] err in
                        guard let self = self else { return }
                        self.isLoading = false
                    }, onCompleted: {[weak self] () in
                        guard let self = self else { return }
                        self.isLoading = false
                    }, onSubscribe: {[weak self] () in
                        guard let self = self else { return }
                        self.isLoading = true
                    })
                }.trackError(self.errorTracker).asDriverOnErrorJustComplete()
            }).drive(self.$item).disposed(by: self.disposeBag)
                
            input.searchbar.do(onNext: {[weak self] text in
                guard let self = self else { return }
                self.isSearching = !text.isEmpty
            }).flatMap{[weak self] search -> Driver<(HomeModel, isLoadMore: Bool)?> in
                guard let self = self else { return Driver.just(nil) }
                return Observable.deferred {
                    if(search.isEmpty) { return Observable.just((self.itemTemp, false)) }
                    return self.service.searchMovies(.init(key: search, type: nil)).map({x in
                        return (x, false)
                    })
                }.trackError(self.errorTracker)
                    .asDriverOnErrorJustComplete()
            }.drive(self.$item)
            .disposed(by: self.disposeBag)
        return Output(data: self.$item.asDriverOnErrorJustComplete(), user: user)
    }
    
}
