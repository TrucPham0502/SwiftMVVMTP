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
        var hhtqEpisode : Driver<String>
    }
    struct Output {
        let item: Driver<DataType>
        let hhtqEpisode : Driver<EpisodeModel?>
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
        
        let hhtqEpisode = input.hhtqEpisode.flatMap({url in
            return Observable.deferred({[weak self] () -> Observable<EpisodeModel?> in
                guard let _self = self else { return Observable.just(nil) }
                return _self.service.hhtqEpisode(.init(url: url)).map({res in
                    guard let id = res?.id, let url = res?.url, let type = res?.type else { return nil}
//                    return EpisodeModel(episode: data.episode, id: id, link: url, isNew: data.isNew, type: type)
                    return nil
                })
            }).trackError(self.errorTracker).trackActivity(self.activityIndicator).asDriverOnErrorJustComplete()
        })
        
        return Output(item: self.$data.asDriverOnErrorJustComplete(), hhtqEpisode : hhtqEpisode.asDriver())
    }
}
