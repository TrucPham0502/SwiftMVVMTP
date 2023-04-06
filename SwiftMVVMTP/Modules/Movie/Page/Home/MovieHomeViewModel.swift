//
//  MovieHomeViewModel.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 24/09/2021.
//

import Foundation
import RxCocoa
import RxSwift
class MovieHomeViewModel : BaseViewModel<MovieHomeViewModel.Input, MovieHomeViewModel.Output> {
    typealias LoadMoreType = (session : Int, data : [MovieCollectionViewCellModel])
    typealias ItemType = (titleData: [MovieCategory], data: [[MovieCollectionViewCellModel]])
    @Dependency.Inject
    var service : MovieService
    var isSearching = false
    var isLoading = false {
        didSet {
            print("loading:\(isLoading)")
        }
    }
    struct Input  {
        var viewWillAppear: Observable<Void>
        var loadMore : Observable<Int>
        var searchbar : Observable<String>
    }
    struct Output {
        let item: Driver<ItemType>
        let loadMore : Driver<LoadMoreType>
    }
    
    var itemTemp : ItemType = ([],[])
    var dataLoaded : Dictionary<Int, Int> = [:]
    @BehaviorRelayProperty(value: ([],[]))
    var item : ItemType
    
    override func transform(input: Input) -> Output {
        input.viewWillAppear.flatMap({[weak self] _ -> Observable<ItemType> in
            guard let _self = self else { return Observable.just(([], [])) }
            return Observable.deferred {() ->  Observable<ItemType> in
                return _self.service.getMovies(.init(page: nil))
            }.trackActivity(_self.activityIndicator)
                .trackError(_self.errorTracker)
        }).do(onNext: {[weak self] data in
            guard let self = self else { return }
            self.itemTemp = data
            self.dataLoaded = data.titleData.enumerated().reduce([:], { partialResult, ele in
                var res = partialResult
                res[ele.offset] = ele.element.nextPage
                return res
            })
        }).asDriverOnErrorJustComplete().drive(self.$item).disposed(by: self.disposeBag)
        
            let loadMore = input.loadMore.filter({[weak self] _ in
                guard let self = self else { return false }
                return !self.isSearching && !self.isLoading
            }).do(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.isLoading = true
            }).flatMap({ section in
            return Observable.deferred { [weak self] () ->  Observable<LoadMoreType> in
                guard let _self = self, let page = _self.dataLoaded[section], page > -1 else {  return Observable.just((section,[])) }
                return _self.service.getMoviesByGroup(.init(page: page)).do(onNext: {[weak self] data in
                    guard let _self = self else { return }
                    _self.dataLoaded[section] = data.page
                }).flatMap({
                    return Observable.just((section,$0.data))
                })
            }
        }).do(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.isLoading = false
        }, onError: {[weak self] err in
            guard let self = self else { return }
            self.isLoading = false
        }).trackError(self.errorTracker).asDriverOnErrorJustComplete()
            
            input.searchbar.do(onNext: {[weak self] text in
                guard let self = self else { return }
                self.isSearching = !text.isEmpty
            }).flatMap{[weak self] search -> Observable<ItemType> in
                guard let self = self else { return Observable.just(([], [])) }
                if(search.isEmpty) { return Observable.just(self.itemTemp) }
                return self.service.searchMovies(.init(key: search))
            }.trackError(self.errorTracker)
            .asDriverOnErrorJustComplete()
            .drive(self.$item)
            .disposed(by: self.disposeBag)
        return Output(item: self.$item.asDriverOnErrorJustComplete(), loadMore: loadMore)
    }
    
}
