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
        }).asDriverOnErrorJustComplete().drive(self.$item).disposed(by: self.disposeBag)
        
            let loadMore = input.loadMore.filter({[weak self] _ in
                guard let self = self else { return false }
                return !self.isSearching
            }).flatMap({ section in
            return Observable.deferred { [weak self] () ->  Observable<LoadMoreType> in
                guard let _self = self else {  return Observable.just((section,[])) }
                let titleData = _self.item.0[section]
                return _self.service.getMoviesByGroup(.init(page: titleData.nextPage)).do(onNext: {[weak self] data in
                    guard let _self = self else { return }
                    _self.item.0[section].nextPage = data.page
                }).flatMap({
                    return Observable.just((section,$0.data))
                })
            }
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
