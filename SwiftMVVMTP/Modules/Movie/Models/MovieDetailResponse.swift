//
//  MovieDetailResponse.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
enum VideoTypeResponse : String, Codable {
    case fileone = "fileone"
    case dailymotion = "dailymotion"
    case fembed = "fembed"
    case normal = "normal"
    init(from decoder: Decoder) throws {
        self = try VideoTypeResponse(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .normal
    }
}
// MARK: - DetailMovieResponse
struct MovieDetailResponse: Codable {
    let episodes: [Episode]?
    let contents: [String]?
    // MARK: - Episode
    struct Episode: Codable {
        let episode: Int?
        let id: String?
        let link: String?
        let isNew: Bool?
        let type: VideoTypeResponse
    }
    
    
}
