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
    
    struct Input {
        let viewWillAppear: Driver<String>
    }
    enum Response {
        case none
        case item(PlayerModel)
    }
    struct Output {
        let item: Driver<Response>
    }
    @Dependency.Inject
    var service : MovieService
    
    @BehaviorRelayProperty(value: .none)
    var item : Response
    
    override func transform(input: Input) -> Output {
        input.viewWillAppear.flatMap({[weak self] urlString in
            guard let self = self else { return Driver.just(.none) }
            return Observable.deferred {
                return self.service.getPlayInfo(urlString).map({x in return .item(x) })
            }.trackActivity(self.activityIndicator)
                .trackError(self.errorTracker)
                .asDriverOnErrorJustComplete()
        }).drive(self.$item)
        .disposed(by: self.disposeBag)
            
        return Output(item: $item.asDriverOnErrorJustComplete())
    }
}
