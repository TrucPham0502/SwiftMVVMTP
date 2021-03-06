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
    typealias ItemType = ([MovieCategory], [[MovieCollectionViewCellModel]])
    @Dependency.Inject
    var service : MovieService
    struct Input  {
        var viewWillAppear: Driver<Void>
        var loadMore : Driver<Int>
    }
    struct Output {
        let item: Driver<ItemType>
        let loadMore : Driver<LoadMoreType>
    }
    
    @BehaviorRelayProperty(value: ([],[]))
    var item : ItemType
    
    override func transform(input: Input) -> Output {
        
        input.viewWillAppear.flatMap({[weak self] _ in
            guard let _self = self else { return Driver.just(([], [])) }
            return Observable.deferred {() ->  Observable<ItemType> in
                return _self.service.getMovieHome(.init(urlPage: nil))
            }.trackActivity(_self.activityIndicator)
                .trackError(_self.errorTracker)
                .asDriverOnErrorJustComplete()
        }).drive(self.$item).disposed(by: self.disposeBag)
        
        let loadMore = input.loadMore.flatMap({ section in
            return Observable.deferred { [weak self] () ->  Observable<LoadMoreType> in
                guard let _self = self else {  return Observable.just((section,[])) }
                let titleData = _self.item.0[section]
                guard let urlPage = titleData.urlPage, !urlPage.isEmpty, titleData.pageType == .hhkungfu else {
                    return Observable.just((section,[]))
                }
                return _self.service.movieLoadMore(.init(urlPage: urlPage)).flatMap({
                    return Observable.just((section,$0))
                })
            }.trackError(self.errorTracker).asDriverOnErrorJustComplete()
        })
        
        return Output(item: self.$item.asDriverOnErrorJustComplete(), loadMore: loadMore)
    }
    
}
