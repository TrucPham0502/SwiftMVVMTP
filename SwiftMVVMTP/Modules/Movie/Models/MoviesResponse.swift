//
//  MovieHomeResponse.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
enum PageType : String, Codable {
    case hhkungfu = "hhkungfu"
    case hhtq = "hhtq"
    case unknown = "default"
    init(from decoder: Decoder) throws {
        self = try PageType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
// MARK: - MovieHomeResponseElement
struct MoviesResponse: Codable {
    let title: String?
    let nextPage: Int?
    let data: [Datum]?
    let pageType: PageType?
    
    // MARK: - Datum
    struct Datum: Codable {
        let url: String?
        let poster: String?
        let name: String?
        let picTag: PicTag?
        let episode: String?
    }

    enum PicTag: String, Codable {
        case vietsub = "VIETSUB"
    }
}


enum VideoTypeResponse : String, Codable {
    case m3u8 = "m3u8"
    case normal = "default"
    init(from decoder: Decoder) throws {
        self = try VideoTypeResponse(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .normal
    }
}

// MARK: - MovieDetailResponse
struct MovieDetailResponse: Codable {
    let time : String?
    let latest : String?
    let season : String?
    let contents: [String]?
    let categorys: [String]?
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


// MARK: - MoviesLinkAndSublinkResponse
struct LinkAndSublinkResponse: Codable {
    let media: Media?
    let sublinks: [Sublink]?
    
    // MARK: - Media
    struct Media: Codable {
        let type: String?
        let url: String?
    }

    // MARK: - Sublink
    struct Sublink: Codable {
        let subsv, name: String?
    }
}


