//
//  AppError.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 17/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
class AppError: Error {
    let error: NSError
    let errorMessage: String
    let errorCode : Int?
    
    init(parseClass: String, errorMessage: String?, errorCode: Int?) {
        let bundle = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        self.errorMessage = errorMessage ?? ""
        self.errorCode = errorCode
        let userInfo: [String : Any] = [
                NSLocalizedDescriptionKey :  NSLocalizedString("NSLocalizedDescriptionKey", value: self.errorMessage, comment: ""),
                NSLocalizedFailureReasonErrorKey : NSLocalizedString("NSLocalizedFailureReasonErrorKey", value: self.errorMessage, comment: "")
        ]
        self.error = NSError(domain: bundle + parseClass, code: errorCode ?? -1, userInfo: userInfo)
    }
}
