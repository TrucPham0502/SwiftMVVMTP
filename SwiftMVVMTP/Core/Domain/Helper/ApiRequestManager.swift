//
//  AppBaseRemoteSource.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

class ApiRequestManager<O : Codable> {
     let manager : Session = Alamofire.Session.default
    func request(
        _ method: HTTPMethod,
        _ url: String,
        parameters: Encodable? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil
    ) -> Observable<ApiResponseDto<O>> {
        #if DEBUG || MOCK
        debugPrint("requestData url : \(String(describing: url))")
        debugPrint("requestData headers : \(String(describing: headers))")
        #endif
        
//        var p : [String: Any]
//        if parameters == nil {
//            p = [
//                "Session": "270A3D4F-1CED-4E00-BEB3-2F87E07748FE",
//                "Type": nil,
//                "OperatorCode":"150"
//                ] as [String : Any]
//        }else{
//            p = parameters!
//        }
        
        return self.manager.rx
            .request(method, url, parameters: parameters?.dictionary ?? [:], encoding: encoding, headers: headers)
            .flatMap {d in
                d.rx.responseData()
            }
            .flatMap { (x) -> Observable<ApiResponseDto<O>> in
                do {
                    let (_, data) = x
                    
                    #if DEBUG || MOCK
                    debugPrint("-------")
                    debugPrint(parameters)
                    debugPrint("-------")
                    //                    debugPrint(response)
                    debugPrint(data)
                    debugPrint(String(decoding: data, as: UTF8.self))
                    debugPrint("-------")
                    #endif
                    
                    let decoder = JSONDecoder()
                    let parseData = try decoder.decode(ApiResponseDto<O>.self, from: data)
                    return Observable.just(parseData)
                } catch {
                    return Observable.error(ParseDataError(parseClass: String(describing: O.self), errorMessage: "invalidJSONData"))
                }
        }
        
    }
    
    func request(
        _ method: HTTPMethod,
        _ url: String,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil
    ) -> Observable<Void> {
        
        #if DEBUG || MOCK
        debugPrint("requestData url : \(String(describing: url))")
        debugPrint("requestData headers : \(String(describing: headers))")
        #endif
        
        return self.manager.rx
            .request(method, url, parameters: parameters, encoding: encoding, headers: headers)
            .flatMap { $0.rx.responseData() }
            .flatMap { (x) -> Observable<Void> in
                return Observable.just(())
        }
        
    }
    
}
