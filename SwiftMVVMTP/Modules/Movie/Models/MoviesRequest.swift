//
//  MovieHomeRequest.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
struct MoviesRequest: Codable {
    let page: Int?
    let type: String?
}
struct SearchMoviesRequest: Codable {
    let key: String
    let type: String?
}
struct MovieDetailRequest: Codable {
    let url: String?
}
struct PlayInfoRequest : Codable {
    let url: String
}

struct SignInRequest : Codable {
    let username : String
    let password: String
    let notificationToken : String
}


struct SetBookmarkRequest : Codable {
    let url: String
    let lastedEpisode : String
}
struct RemoveBookmarkRequest : Codable {
    let url: String
}

struct ProcessDataRequest : Codable {
    let type: String
    let url : String
    let body : String
}

