//
//  MovieDetailViewModel.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxCocoa
import RxSwift
protocol MovieDetailViewLogic : BaseViewLogic {
    
}
class MovieDetailViewModel : BaseViewModel<MovieDetailViewModel.Input, MovieDetailViewModel.Output> {
    @Dependency.Inject
    var service : MovieService
    
    typealias DataType = ([EpisodeModel], content: String, time: String, season: String, latest: String, categorys : String)
    
    @BehaviorRelayProperty(value: ([], "", "", "", "", ""))
    var data : DataType
    
    weak var viewLogic : MovieDetailViewLogic?
    
    struct Input  {
        let viewWillAppear: Driver<String>
    }
    struct Output {
        let item: Driver<DataType>
    }
    
    override func transform(input: Input) -> Output {
        input.viewWillAppear.flatMap({ urlString in
            return Observable.deferred({[weak self] () -> Observable<DataType> in
                guard let _self = self else { return Observable.just(([], "", "", "", "","")) }
                return _self.service.movieDetail(.init(url: urlString))
            }).trackError(self.errorTracker)
                .asDriverOnErrorJustComplete()
        }).drive(self.$data).disposed(by: self.disposeBag)
        
        return Output(item: self.$data.asDriverOnErrorJustComplete())
    }
}
