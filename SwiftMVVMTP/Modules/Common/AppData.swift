//
//  AppData.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 13/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
class AppData {
    static func logout(){
        Storage<User>.remove(key: StorageKey.USER_INFO.rawValue)
        Storage<User>.remove(key: Authorization.key, group: Constants.groupShared)
    }
    static func saveDataUser(user: User, author: Authorization){
        Storage.set(data: user, key: StorageKey.USER_INFO.rawValue)
        Storage.set(data: author, key: Authorization.key, group: Constants.groupShared)
    }
}
