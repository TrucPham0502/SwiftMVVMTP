//
//  ParseDataError.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import Foundation
class ParseDataError: Error {
    
    let error: NSError
    let errorMessage: String
    
    init(parseClass: String, errorMessage: String) {
        let bundle = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        self.error = NSError(domain: bundle + parseClass, code: -1, userInfo: nil)
        self.errorMessage = errorMessage
    }
}
