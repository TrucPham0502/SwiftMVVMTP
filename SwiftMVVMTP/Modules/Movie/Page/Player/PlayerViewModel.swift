//
//  PlayerViewModel.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 05/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PlayerViewModel : BaseViewModel<PlayerViewModel.Input, PlayerViewModel.Output> {
    enum PlayType {
        case url(url: String)
        case sublink(url: String, sublink: String)
    }
    struct Input {
        let viewWillAppear: Driver<PlayType>
    }

    struct Output {
        let item: Driver<PlayerModel?>
    }
    @Dependency.Inject
    var service : MovieService
    
    @BehaviorRelayProperty(value: nil)
    var item : PlayerModel?
    
    override func transform(input: Input) -> Output {
        input.viewWillAppear.flatMap({[weak self] type -> Driver<PlayerModel?> in
            guard let self = self else { return Driver.just(nil) }
            return Observable.deferred {
                switch type {
                case .url(let urlString):
                    return self.service.getPlayInfo(urlString).map({x in return x })
                case let .sublink(urlString, sublink):
                    return self.service.getPlayInfo(urlString, sublink: sublink).map({x in return x })
                }
                
            }.trackActivity(self.activityIndicator, message: "Retrieving video information")
                .trackError(self.errorTracker)
                .asDriverOnErrorJustComplete()
        }).drive(self.$item)
        .disposed(by: self.disposeBag)
            
        return Output(item: $item.asDriverOnErrorJustComplete())
    }
}
