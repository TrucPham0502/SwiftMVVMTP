//
//  AppData.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 11/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
@propertyWrapper
struct Printable {
    private var value: String = ""

    var wrappedValue: String {
        get {
            // Intercept read operation & print to console
            print("Get value: \(value)")
            return value
        }
        set {
            // Intercept write operation & print to console
            print("Set value: \(newValue)")
            value = newValue
        }
    }
}

@propertyWrapper
struct Storage<T: Codable> {
    static func remove(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    static func set(data : T, key: String) {
        let save = try? JSONEncoder().encode(data)
        UserDefaults.standard.set(save, forKey: key)
    }
    static func get(key: String) -> T? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
            return nil
        }
        let value = try? JSONDecoder().decode(T.self, from: data)
        return value
    }
    
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return Storage<T>.get(key: key) ?? defaultValue
        }
        set {
            Storage<T>.set(data: newValue, key: key)
        }
    }
}
@propertyWrapper
struct EncryptedStringStorage {

    private let key: String

    init(key: String) {
        self.key = key
    }

    var wrappedValue: String {
        get {
            // Get encrypted string from UserDefaults
            return UserDefaults.standard.string(forKey: key) ?? ""
        }
        set {
            // Encrypt newValue before set to UserDefaults
            let encrypted = encrypt(value: newValue)
            UserDefaults.standard.set(encrypted, forKey: key)
        }
    }

    private func encrypt(value: String) -> String {
        // Encryption logic here
        return String(value.reversed())
    }
}

struct Authorization : Codable {
    static let key = "AUTHORIZATION_KEY"
    let token : String
    let refreshToken: String
    let privateKey : String
}
