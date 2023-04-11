//
//  LoginViewModel.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 10/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
class LoginViewModel : BaseViewModel<LoginViewModel.Input, LoginViewModel.Output> {
    struct Input {
        let viewWillAppear : Observable<()>
        let signIn : Driver<(userName: String, password: String)>
    }
    struct Output {
        let result : Driver<Response>
    }
    enum Response {
        case none
        case login
    }
    
    @Dependency.Inject
    var service : MovieService
    
    @BehaviorRelayProperty(value: .none)
    var result : Response
    
    
    override func transform(input: Input) -> Output {
        input.signIn.flatMap{[weak self] (username, password)  -> Driver<Response> in
            guard let self = self else { return Driver.just(.none) }
            return Observable.deferred {
                return self.service.signIn(.init(username: username, password: password, notificationToken: Storage<String>.get(key: StorageKey.NOTIFICATION_TOKEN.rawValue) ?? "")).map({ () in return .login })
                }.trackError(self.errorTracker)
                .trackActivity(self.activityIndicator)
                .asDriverOnErrorJustComplete()
            }.drive(self.$result)
            .disposed(by: self.disposeBag)
        return Output(result: $result.asDriverOnErrorJustComplete())
    }
    
}
