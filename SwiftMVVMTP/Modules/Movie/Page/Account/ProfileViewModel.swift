//
//  ProfileViewModel.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 13/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
struct ProfileItemModel {
    let icon : UIImage?
    let title : String
    let type : DataType
    enum DataType {
        case logout, personal, support
    }
}
class ProfileViewModel : BaseViewModel<ProfileViewModel.Input, ProfileViewModel.Output> {
    struct Input {
        let viewWillAppear : Driver<()>
        let itemSelected : Driver<ProfileItemModel>
    }
    enum Response {
        case none
        case item(User?)
        case itemSelected(ProfileItemModel)
    }
    struct Output {
        let result : Driver<Response>
    }
    
    @Dependency.Inject
    var service : MovieService
    
    @BehaviorRelayProperty(value: .none)
    var result : Response
    
    @Storage(key: StorageKey.USER_INFO.rawValue, defaultValue: nil)
    var userInfo : User?
    
    override func transform(input: Input) -> Output {
        input.viewWillAppear.flatMap({[weak self] () in
            guard let self = self else { return Driver.just(Response.none) }
            return Observable.deferred({() -> Observable<Response> in
                return Observable.just(.item(self.userInfo))
            }).trackActivity(self.activityIndicator)
                .trackError(self.errorTracker)
                .asDriverOnErrorJustComplete()
        }).drive(self.$result)
            .disposed(by: self.disposeBag)
        
        input.itemSelected.flatMap({[weak self] (data) in
            guard let self = self else { return Driver.just(Response.none) }
            return Observable.deferred({() -> Observable<Response> in
                switch data.type {
                case .logout:
                    AppData.logout()
                default: break
                }
                return Observable.just(.itemSelected(data))
            }).trackActivity(self.activityIndicator)
                .trackError(self.errorTracker)
                .asDriverOnErrorJustComplete()
        }).drive(self.$result)
            .disposed(by: self.disposeBag)
        
        return Output(result: self.$result.asDriverOnErrorJustComplete())
    }
}
