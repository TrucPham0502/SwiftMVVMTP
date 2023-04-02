//
//  HMAC.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 02/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import CommonCrypto
struct HMAC {

    static func hash(inp: String, algo: HMACAlgo) -> String {
        if let stringData = inp.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            return hexStringFromData(input: digest(input: stringData as NSData, algo: algo))
        }
        return ""
    }

    private static func digest(input : NSData, algo: HMACAlgo) -> NSData {
        let digestLength = algo.digestLength()
        var hash = [UInt8](repeating: 0, count: digestLength)
        switch algo {
        case .MD5:
            CC_MD5(input.bytes, UInt32(input.length), &hash)
            break
        case .SHA1:
            CC_SHA1(input.bytes, UInt32(input.length), &hash)
            break
        case .SHA224:
            CC_SHA224(input.bytes, UInt32(input.length), &hash)
            break
        case .SHA256:
            CC_SHA256(input.bytes, UInt32(input.length), &hash)
            break
        case .SHA384:
            CC_SHA384(input.bytes, UInt32(input.length), &hash)
            break
        case .SHA512:
            CC_SHA512(input.bytes, UInt32(input.length), &hash)
            break
        }
        return NSData(bytes: hash, length: digestLength)
    }
    
    static func hmacSHA512(message: String, secretKey: String) -> String? {
        guard let messageData = message.data(using: .utf8),
              let keyData = secretKey.data(using: .utf8) else {
            return nil
        }

        var digestData = Data(count: Int(CC_SHA512_DIGEST_LENGTH))
        digestData.withUnsafeMutableBytes { digestBytes -> Void in
            messageData.withUnsafeBytes { messageBytes -> Void in
                keyData.withUnsafeBytes { keyBytes -> Void in
                    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA512), keyBytes.baseAddress, keyData.count, messageBytes.baseAddress, messageData.count, digestBytes.baseAddress)
                }
            }
        }

        return digestData.map { String(format: "%02x", $0) }.joined()
    }

    private static func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)

        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }

        return hexString
    }
}

enum HMACAlgo {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512

    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}
