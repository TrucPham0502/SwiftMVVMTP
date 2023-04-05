//
//  MovieDetailResponse.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
enum VideoTypeResponse : String, Codable {
    case m3u8 = "m3u8"
    case normal = "default"
    case dailymotion = "dailymotion"
    init(from decoder: Decoder) throws {
        self = try VideoTypeResponse(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .normal
    }
}

// MARK: - MovieDetailResponse
struct MovieDetailResponse: Codable {
    let defaultUrl : String?
    let season : String?
    let contents: [String]?
    let episodes: [Episode]?
    // MARK: - Episode
    struct Episode: Codable {
        let dataPostId, dataServer, dataEpisodeSlug, dataEmbed, episode,url : String?
        let isNew : Bool?
        let dataPosition : DataPosition?
        
        enum DataPosition: String, Codable {
            case empty = ""
            case first = "first"
            case last = "last"
        }
    }
}




