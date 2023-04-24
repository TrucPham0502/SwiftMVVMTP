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
    let sublinks: [(name: String, data: String)]
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
    let picTag: String
}
protocol MovieDetailViewLogic : BaseViewLogic {
    
}
class MovieDetailViewModel : BaseViewModel<MovieDetailViewModel.Input, MovieDetailViewModel.Output> {
    @Dependency.Inject
    var service : MovieService
    
    @Storage(key: StorageKey.USER_INFO.rawValue, defaultValue: nil)
    var user : User?
    
    @BehaviorRelayProperty(value: nil)
    var data : MovieDetailModel?
    
    weak var viewLogic : MovieDetailViewLogic?
    
    struct Input  {
        let viewWillAppear: Driver<String>
        let bookmark : Driver<(Bool, String, String)>
    }

    struct Output {
        let item: Driver<MovieDetailModel?>
        let bookmark : Driver<()>
    }
    
    override func transform(input: Input) -> Output {
        input.viewWillAppear.flatMap({[weak self] urlString -> Driver<MovieDetailModel?> in
            guard let self = self else { return Driver.just(nil) }
            return Observable.deferred {() -> Observable<MovieDetailModel?> in
                return self.service.movieDetail(.init(url: urlString)).map({x in
                     return x
                })
            }.trackError(self.errorTracker).asDriverOnErrorJustComplete()
        }).drive(self.$data).disposed(by: self.disposeBag)
        
        let bookmark = input.bookmark.flatMap({[weak self] (isSelected, url, lastedEp) -> Driver<()> in
            guard let self = self else { return Driver.just(()) }
            return Observable<()>.deferred {
                guard let _ = self.user else {
                   throw AppError(parseClass: "MovieDetailViewModel", errorMessage: "You need to login to perform this function", errorCode: -2)
                }
                if isSelected {
                    return self.service.setBookmark(.init(url: url, lastedEpisode: lastedEp))
                }
                return self.service.removeBookmark(.init(url: url))
            }
            .mapToVoid()
            .trackError(self.errorTracker)
            .trackActivity(self.activityIndicator)
            .asDriverOnErrorJustComplete()
        })
        
        return Output(item: self.$data.asDriverOnErrorJustComplete(), bookmark: bookmark)
    }
}
