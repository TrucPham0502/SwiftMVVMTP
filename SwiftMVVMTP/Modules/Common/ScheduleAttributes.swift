//
//  ScheduleAttributes.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 11/05/2023.
//  Copyright © 2023 TrucPham. All rights reserved.
//

import Foundation
import ActivityKit
struct ScheduleAttributes : ActivityAttributes {
    public struct ContentState : Codable, Hashable {
        var name : String
    }
}
