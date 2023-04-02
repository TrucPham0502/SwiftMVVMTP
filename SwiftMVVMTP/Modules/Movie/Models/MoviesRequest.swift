//
//  MovieHomeRequest.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
struct MoviesRequest: Codable {
    let page: Int?
}
struct SearchMoviesRequest: Codable {
    let key: String
}
