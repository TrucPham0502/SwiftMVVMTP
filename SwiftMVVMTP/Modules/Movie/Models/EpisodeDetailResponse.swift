//
//  EpisodeDetailResponse.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 17/11/2022.
//  Copyright © 2022 Truc Pham. All rights reserved.
//

import Foundation
// MARK: - EpisodeDetailResponse
struct EpisodeDetailResponse: Codable {
    let data: DataClass?
    enum VideoType : String, Codable {
        case dailymotion = "dailymotion"
        case m3u8 = "m3u8"
        case normal = "default"
    }
    // MARK: - DataClass
    struct DataClass: Codable {
        let status: Bool?
        let sources: String?
        let iframe: String?
        let type: VideoType?
        let url: String?
    }
}

