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
        let result : Driver<()>
    }
    
    @Dependency.Inject
    var service : MovieService
    
    
    
    override func transform(input: Input) -> Output {
        let signIn = input.signIn.flatMap{[weak self] (username, password)  -> Driver<()> in
            guard let self = self else { return Driver.just(()) }
            return Observable.deferred {
                return self.service.signIn(.init(username: username, password: password, notificationToken: Storage<String>.get(key: StorageKey.NOTIFICATION_TOKEN.rawValue) ?? "")).mapToVoid()
                }.trackError(self.errorTracker)
                .trackActivity(self.activityIndicator)
                .asDriverOnErrorJustComplete()
            }
        return Output(result: signIn)
    }
    
}
