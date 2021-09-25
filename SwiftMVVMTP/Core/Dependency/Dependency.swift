//
//  Dependency.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import Foundation
struct Dependency {
    
    class Module  {
        func register(_ dependency : Dependency){}
    }
    
    static let shared : Dependency = .init()
    private static var services: [String: NSObject.Type] = [:]
    func build(_ module : [Module]) {
        module.forEach({ $0.register(self) })
    }
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
    struct Inject<T>{
        var wrappedValue : T {
            return Dependency.shared.resolve(T.self)
        }
    }
    @propertyWrapper
    struct InfoDictionary<T> {
        var wrappedValue : T {
            if let result = Bundle.main.object(forInfoDictionaryKey: key) as? T {
                return result
            }
            fatalError("\(key) can not found")
            
        }
        let key : String
        init(key: String){
            self.key = key
        }
    }

}

