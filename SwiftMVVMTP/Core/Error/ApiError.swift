//
//  ApiError.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 24/09/2021.
//

import Foundation
class ApiError: Error {
    let error: NSError
    let errorMessage: String
    
    init(parseClass: String, errorMessage: String?, errorCode: Int?) {
        let bundle = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        self.errorMessage = errorMessage ?? ""
        let userInfo: [String : Any] = [
                NSLocalizedDescriptionKey :  NSLocalizedString("NSLocalizedDescriptionKey", value: self.errorMessage, comment: ""),
                NSLocalizedFailureReasonErrorKey : NSLocalizedString("NSLocalizedFailureReasonErrorKey", value: self.errorMessage, comment: "")
        ]
        self.error = NSError(domain: bundle + parseClass, code: errorCode ?? -1, userInfo: userInfo)
    }
}
