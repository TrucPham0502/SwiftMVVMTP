//
//  MovieDetailViewModel.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxCocoa
import RxSwift
class MovieDetailViewModel : BaseViewModel<MovieDetailViewModel.Input, MovieDetailViewModel.Output> {
    @Dependency.Inject
    var service : MovieService
    
    typealias DataType = ([EpisodeModel], String)
    
    @BehaviorRelayProperty(value: ([], ""))
    var data : DataType
    
    
    struct Input  {
        var viewWillAppear: Driver<Void>
        var url : String
        var pageType : PageType
    }
    struct Output {
        let item: Driver<DataType>
    }
    
    override func transform(input: Input) -> Output {
        input.viewWillAppear.flatMap({
            return Observable.deferred({[weak self] () -> Observable<DataType> in
                guard let _self = self else { return Observable.just(([], "")) }
                return _self.service.movieDetail(.init(url: input.url), pageType: input.pageType)
            }).trackError(self.errorTracker)
                .trackActivity(self.activityIndicator)
                .asDriverOnErrorJustComplete()
        }).drive(self.$data).disposed(by: self.disposeBag)
        return Output(item: self.$data.asDriverOnErrorJustComplete())
    }
}
