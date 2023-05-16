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
        var teamA : Team
        var teamB : Team
        var state : State = .playing
    }
    struct Team : Codable, Hashable {
        let id : TeamId
        let scored : [Score]
        let primaryColor : String
        struct Score : Codable, Hashable {
            let name : String
            let time : Int
        }
    }
    enum State : String, Codable, Hashable{
        case playing, end
    }
    enum TeamId : String, Codable, Hashable {
        case manchester_city = "Manchester_City"
        case manchester_united = "Manchester_United"
        var name : String {
            switch self {
            case .manchester_city:
                return "Manchester City"
            case .manchester_united:
                return "Manchester United"
            }
        }
    }
}
