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

    struct Output {
        let item: Driver<PlayerModel?>
    }
    @Dependency.Inject
    var service : MovieService
    
    @BehaviorRelayProperty(value: nil)
    var item : PlayerModel?
    
    override func transform(input: Input) -> Output {
        input.viewWillAppear.flatMap({[weak self] urlString -> Driver<PlayerModel?> in
            guard let self = self else { return Driver.just(nil) }
            return Observable.deferred {
                return self.service.getPlayInfo(urlString).map({x in return x })
            }.trackActivity(self.activityIndicator)
                .trackError(self.errorTracker)
                .asDriverOnErrorJustComplete()
        }).drive(self.$item)
        .disposed(by: self.disposeBag)
            
        return Output(item: $item.asDriverOnErrorJustComplete())
    }
}
