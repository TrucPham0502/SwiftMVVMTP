//
//  Constants.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import Foundation
enum InfoDictionary : String {
    case appEndPointUrl = "AppEndPointUrl"
}
struct Constants {
    
    static var appEndPointUrl : String {
        #if targetEnvironment(simulator)
        // Simulator
        return "http://192.168.46.103:8000/"
        #else
        // Device
        @Dependency.InfoDictionary(key: InfoDictionary.appEndPointUrl.rawValue)
        var appEndPointUrl : String
        return appEndPointUrl
        #endif
    }
    
    
    
//    private init(){}
//    static func setPageType(pageType : PageType) -> Constants {
//        var config = Constants()
//        config.pageType = pageType
//        return config
//    }
//    fileprivate var pageType : PageType = .hhkungfu
//
//    var path : String {
//        return host + "api/" + pageType.rawValue
//    }
//    var homeApi : String{
//        return "\(path)/list"
//    }
//    var urlM3u8 : String{ "\(host)api/dailymotion?id=%@" }
//    var urlFileone : String{ "\(host)api/fileone" }
//    var urlFembed : String{ "\(host)api/fembed?id=%@" }
//    var detailMovie : String{ "\(path)/detail" }
//    var urlhhtqGetEpisode : String {
//        return host + "api/hhtq/getepisode"
//    }
}
