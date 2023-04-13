//
//  DeepLink.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 13/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit
// Example - demoapp://open/page/ViewController?id=1&value=2
struct OpenPageDeepLink: DeepLink {
    static let template = DeepLinkTemplate()
        .term("open")
        .term("page")
        .string(named: "name")
    
    init(values: DeepLinkValues) {
        guard let viewControllerName = values.path["name"] as? String else { return }
        if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            print("CFBundleName - \(appName)")
            if let viewControllerType = NSClassFromString("\(appName.replacingOccurrences(of: " ", with: "_")).\(viewControllerName)") as? AppBaseViewController.Type {
                let vc = viewControllerType.init()
                vc.deepLink(receive: values)
                if let viewController = UIApplication.shared.keyWindow?.rootViewController {
                    vc.modalPresentationStyle = .fullScreen
                    viewController.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
}
// Example - demoapp://open/alert?message=m&title=t&type=success
//type : error - success
struct OpenAlertDeepLink: DeepLink {
    static let template = DeepLinkTemplate()
        .term("open")
        .term("alert")
    
    init(values: DeepLinkValues) {
        if let message = values.query["message"]?.removingPercentEncoding,let title = values.query["title"]?.removingPercentEncoding {
            let type = values.query["type"] ?? "success"
            print("\(message) --- \(title)")
        }
    }
}
