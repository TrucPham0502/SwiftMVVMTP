//
//  String+Extensions.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 02/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
extension String {
    var md5: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.MD5)
    }

    var sha1: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.SHA1)
    }

    var sha224: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.SHA224)
    }

    var sha256: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.SHA256)
    }

    var sha384: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.SHA384)
    }

    var sha512: String {
        return HMAC.hash(inp: self, algo: HMACAlgo.SHA512)
    }
    func hmacSHA512(key : String) -> String? {
        return HMAC.hmacSHA512(message: self, secretKey: key)
    }
}
