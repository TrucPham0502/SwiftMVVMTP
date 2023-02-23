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
struct MovieHomeResponse: Codable {
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
    }

    enum PicTag: String, Codable {
        case vietsub = "VIETSUB"
    }
}


