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
        let viewWillAppear: Observable<String>
    }
    struct Output {
        let item: Driver<PlayerModel>
    }
    @Dependency.Inject
    var service : MovieService
    
    @BehaviorRelayProperty(value: PlayerModel(media: .init(url: "", type: ""), sublinks: []))
    var item : PlayerModel
    
    override func transform(input: Input) -> Output {
        input.viewWillAppear.flatMap({[weak self] urlString -> Observable<PlayerModel> in
            guard let _self = self else { return Observable.empty() }
            return _self.service.getLinkAndSublink(urlString)
        }).trackActivity(self.activityIndicator)
            .trackError(self.errorTracker)
            .asDriverOnErrorJustComplete()
            .drive(self.$item)
            .disposed(by: self.disposeBag)
            
        return Output(item: $item.asDriverOnErrorJustComplete())
    }
}
