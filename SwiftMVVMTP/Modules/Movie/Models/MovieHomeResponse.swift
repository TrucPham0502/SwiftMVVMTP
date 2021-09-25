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
    case unknown = "common"
    init(from decoder: Decoder) throws {
        self = try PageType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
struct MovieHomeResponse: Codable {
    let urlPage: String?
    let title : String?
    let data: [Datum]?
    let pageType : PageType
    // MARK: - Datum
    struct Datum: Codable {
        let url: String?
        let poster: String?
        let name: String?
        let picTag : String?
    }
}
