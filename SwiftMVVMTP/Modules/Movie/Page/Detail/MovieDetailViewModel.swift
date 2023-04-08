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
        let viewWillAppear: Observable<String>
    }
    enum Response {
        case none
        case item(MovieDetailModel)
    }
    struct Output {
        let item: Driver<Response>
    }
    
    override func transform(input: Input) -> Output {
        input.viewWillAppear.flatMap({[weak self] urlString -> Observable<Response>  in
            guard let _self = self else { return Observable.just(.none) }
            return _self.service.movieDetail(.init(url: urlString)).map({x in
                return .item(x)
            })
        }).trackError(self.errorTracker)
        .asDriverOnErrorJustComplete()
        .drive(self.$data).disposed(by: self.disposeBag)
        
        return Output(item: self.$data.asDriverOnErrorJustComplete())
    }
}
