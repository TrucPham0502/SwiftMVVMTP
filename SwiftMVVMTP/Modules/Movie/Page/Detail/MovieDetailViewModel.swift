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
    
    typealias DataType = ([EpisodeModel], String)
    
    @BehaviorRelayProperty(value: ([], ""))
    var data : DataType
    
    @BehaviorRelayProperty(value: nil)
    var currentUrl : URL?
    
    weak var viewLogic : MovieDetailViewLogic?
    
    struct Input  {
        let viewWillAppear: Driver<Void>
        let openVideo : Driver<EpisodeModel>
        let url : String
        let pageType : PageType
    }
    struct Output {
        let item: Driver<DataType>
        let openVideo : Driver<URL?>
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
        
        input.openVideo.flatMap({ data in
            return Observable.deferred({[weak self] () -> Observable<URL?> in
                guard let _self = self else { return Observable.just(nil) }
                return RxPlayerHelper.shared.openPlayer(_self.viewLogic as! UIViewController, data: data, openVideoController: false).map { d in
                    guard let data = d else { return nil }
                    let urls = RxPlayerHelper.shared.getUrl(data)
                    return urls.first
                }
            }).trackError(self.errorTracker)
                .trackActivity(self.activityIndicator)
                .asDriverOnErrorJustComplete()
        }).drive(self.$currentUrl).disposed(by: self.disposeBag)
        
        return Output(item: self.$data.asDriverOnErrorJustComplete(), openVideo: self.$currentUrl.asDriverOnErrorJustComplete())
    }
}
