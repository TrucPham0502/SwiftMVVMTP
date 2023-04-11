//
//  MovieDetailViewModel.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxCocoa
import RxSwift
struct EpisodeModel {
    let episode: String
    let url : String
}

struct MovieDetailModel {
    let title: String
    let episodes: [EpisodeModel]
    let content: String
    let time: String
    let season: String
    let latest: String
    let categorys : String
    let isBookmark: Bool
}
protocol MovieDetailViewLogic : BaseViewLogic {
    
}
class MovieDetailViewModel : BaseViewModel<MovieDetailViewModel.Input, MovieDetailViewModel.Output> {
    @Dependency.Inject
    var service : MovieService
    
    @BehaviorRelayProperty(value: .none)
    var data : Response
    
    weak var viewLogic : MovieDetailViewLogic?
    
    struct Input  {
        let viewWillAppear: Driver<String>
        let bookmark : Driver<(Bool, String, String)>
    }
    enum Response {
        case none
        case item(MovieDetailModel)
    }
    struct Output {
        let item: Driver<Response>
    }
    
    override func transform(input: Input) -> Output {
        input.viewWillAppear.flatMap({[weak self] urlString in
            guard let self = self else { return Driver.just(.none) }
            return Observable.deferred {
                return self.service.movieDetail(.init(url: urlString)).map({x in
                    return .item(x)
                }).trackError(self.errorTracker)
            }.asDriverOnErrorJustComplete()
        }).drive(self.$data).disposed(by: self.disposeBag)
        
        input.bookmark.flatMap({[weak self] (isSelected, url, lastedEp) in
            guard let self = self else { return Driver.just(Response.none) }
            return Observable.deferred {
                if isSelected {
                    return self.service.setBookmark(.init(url: url, lastedEpisode: lastedEp))
                }
                return self.service.removeBookmark(.init(url: url))
            }
            .map{_ in return Response.none }
            .trackError(self.errorTracker)
            .trackActivity(self.activityIndicator)
            .asDriverOnErrorJustComplete()
        }).drive(self.$data).disposed(by: self.disposeBag)
        
        return Output(item: self.$data.asDriverOnErrorJustComplete())
    }
}
