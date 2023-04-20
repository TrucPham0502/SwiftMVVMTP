//
//  MovieHomeResponse.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
// MARK: - MovieHomeResponseElement
struct MoviesResponse: Codable {
    let title: String?
    let nextPage: Int?
    let data: [Datum]?
    let pageType: String?
    
    // MARK: - Datum
    struct Datum: Codable {
        let url: String?
        let poster: String?
        let name: String?
        let picTag: String?
        let episode: String?
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
    let title: String?
    let time : String?
    let latest : String?
    let season : String?
    let contents: [String]?
    let categorys: [String]?
    let episodes: [Episode]?
    let isBookmark: Bool?
    let picTag : String?
    // MARK: - Episode
    struct Episode: Codable {
        let episode,url : String?
    }
}


// MARK: - MoviesLinkAndSublinkResponse
struct PlayInfoResponse: Codable {
    var media: Media?
    let sublinks: [Sublink]?
    
    // MARK: - Media
    struct Media: Codable {
        var type: MediaType?
        var url: String?
        enum MediaType : String, Codable {
            case client = "client_process"
            case m3u8 = "m3u8"
            case `default` = "default"
        }
    }

    // MARK: - Sublink
    struct Sublink: Codable {
        let subsv, name: String?
    }
}


// MARK: - SignInResponse
struct SignInResponse: Codable {
    let user: User?
    let token, refreshToken, privateKey: String?
}

// MARK: - User
struct User: Codable {
    let id, username, password, address: String?
    let email, fax: String?
    let facebook, youtube, twitter, linkedin: String?
    let googlePlus, instagram: String?
    let phoneNumber, firstName, lastName, nationalID: String?
    let bankID, bankNumber, cardHolderName, qr: String?
    let qrNote, role: String?

    enum CodingKeys: String, CodingKey {
        case id, username, password, address, email, fax, facebook, youtube, twitter, linkedin, googlePlus, instagram, phoneNumber, firstName, lastName
        case nationalID = "nationalId"
        case bankID = "bankId"
        case bankNumber, cardHolderName, qr, qrNote, role
    }
}
