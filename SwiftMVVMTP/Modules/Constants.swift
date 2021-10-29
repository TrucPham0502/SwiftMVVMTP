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
    @Dependency.InfoDictionary(key: InfoDictionary.appEndPointUrl.rawValue)
    static var appEndPointUrl : String
    
    
    
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
