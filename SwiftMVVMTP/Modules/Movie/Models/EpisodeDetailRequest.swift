//
//  EpisodeDetailRequest.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 17/11/2022.
//  Copyright © 2022 Truc Pham. All rights reserved.
//

import Foundation

// MARK: - EpisodeDetailRequest
struct EpisodeDetailRequest: Codable {
    let episodeSlug, serverID, subsvID, postID: String?
    let nonce, customVar: String?

    enum CodingKeys: String, CodingKey {
        case episodeSlug
        case serverID = "serverId"
        case subsvID = "subsvId"
        case postID = "postId"
        case nonce, customVar
    }
}
