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
    struct Output {
        let result : Driver<User?>
        let itemSelected : Driver<ProfileItemModel>
    }
    
    @Dependency.Inject
    var service : MovieService
    
    @Storage(key: StorageKey.USER_INFO.rawValue, defaultValue: nil)
    var userInfo : User?
    
    override func transform(input: Input) -> Output {
        let data = input.viewWillAppear.flatMap({[weak self] () -> Driver<User?> in
            guard let self = self else { return Driver.just(nil) }
            return Observable.deferred({() -> Observable<User?> in
                return Observable.just(self.userInfo)
            }).trackActivity(self.activityIndicator)
                .trackError(self.errorTracker)
                .asDriverOnErrorJustComplete()
        })
        
        let itemSelected = input.itemSelected.flatMap({[weak self] (data) -> Driver<ProfileItemModel> in
            guard let self = self else { return Driver.just(data) }
            return Observable.deferred({() -> Observable<ProfileItemModel> in
                switch data.type {
                case .logout:
                    AppData.logout()
                default: break
                }
                return Observable.just(data)
            }).trackActivity(self.activityIndicator)
                .trackError(self.errorTracker)
                .asDriverOnErrorJustComplete()
        })
        
        return Output(result: data, itemSelected: itemSelected)
    }
}
