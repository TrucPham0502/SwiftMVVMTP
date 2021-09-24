//
//  Dependency.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import Foundation
struct Dependency {
    static let shared : Dependency = .init()
    private static var services: [String: NSObject.Type] = [:]
    
    func register<P>(_ pro: P.Type, service : NSObject.Type) {
        Dependency.services[String(describing: pro)] = service
    }
    
    func resolve<T>(_ type : T.Type) -> T {
        if let s = Dependency.services[String(describing: T.self)], let res = s.init() as? T {
            return res
        }
        else {
            fatalError("Can not found \(String(describing: T.self))")
        }
    }

    @propertyWrapper
    struct Get<T>{
        var wrappedValue : T {
            return Dependency.shared.resolve(T.self)
        }
    }


}

