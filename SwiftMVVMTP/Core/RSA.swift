//
//  RSA.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 14/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import Security
class RSA {
    static func removePEMHeaders(from pem: String, header: String, footer: String) -> String? {
        guard let headerRange = pem.range(of: header),
              let footerRange = pem.range(of: footer) else {
            return nil
        }
        return String(pem[headerRange.upperBound..<footerRange.lowerBound])
    }
    static func signMessage(_ message: String, pem privateKey: String) -> Data? {
        guard let messageData = message.data(using: .utf8) else {
            print("Error converting message to data")
            return nil
        }
        let privateKeyHeader = "-----BEGIN RSA PRIVATE KEY-----"
           let privateKeyFooter = "-----END RSA PRIVATE KEY-----"
        var pemContent: String?
        
        if let privateKeyContent = removePEMHeaders(from: privateKey, header: privateKeyHeader, footer: privateKeyFooter) {
            pemContent = privateKeyContent
        } else {
            print("Invalid PEM string")
            return nil
        }
        guard let base64Content = pemContent?.replacingOccurrences(of: "\n", with: ""), let keyData = Data(base64Encoded: base64Content) else {
                print("Unable to decode PEM content")
                return nil
            }
        
        let keyDict: [CFString: Any] = [
               kSecAttrKeyType: kSecAttrKeyTypeRSA,
               kSecAttrKeyClass: kSecAttrKeyClassPrivate,
               kSecAttrKeySizeInBits: NSNumber(value: 1024),
               kSecReturnPersistentRef: true
           ]
            
        
        var error: Unmanaged<CFError>?
        let secKey = SecKeyCreateWithData(keyData as CFData, keyDict as CFDictionary, &error)
        
        if let error = error {
               print("Error creating SecKey: \(error)")
               return nil
        }
        
        guard let signature = SecKeyCreateSignature(
            secKey!,
            .rsaSignatureMessagePKCS1v15SHA512,
            messageData as CFData,
            &error
        ) else {
            print("Error signing message: \(error!.takeRetainedValue() as Error)")
            return nil
        }
        
        return signature as Data
    }

    func decryptWithPublicKey(data: Data, publicKey: SecKey) -> Data? {
        var error: Unmanaged<CFError>?
        guard let decryptedData = SecKeyCreateDecryptedData(publicKey, .rsaEncryptionPKCS1, data as CFData, &error) as Data? else {
            print("Decryption error: \((error?.takeRetainedValue().localizedDescription) ?? "Unknown error")")
            return nil
        }
        return decryptedData
    }
    
    func generateRSAKeyPair() -> (privateKey: SecKey, publicKey: SecKey)? {
        let parameters: [String: Any] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 2048
        ]

        var error: Unmanaged<CFError>?
        guard let privateKey = SecKeyCreateRandomKey(parameters as CFDictionary, &error) else {
            print("Key generation error: \((error?.takeRetainedValue().localizedDescription) ?? "Unknown error")")
            return nil
        }

        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            print("Failed to get public key")
            return nil
        }

        return (privateKey: privateKey, publicKey: publicKey)
    }


}
