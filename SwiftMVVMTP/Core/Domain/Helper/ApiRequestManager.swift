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
    @Storage(key: Authorization.key, defaultValue: nil)
    var authorization : Authorization?
    let manager : Session = Alamofire.Session.default
    func signature(data: Encodable, nonce : String, timestamp: String) -> String {
        var dic = (try? data.asDictionary()) ?? [:]
        dic["nonce"] = nonce
        dic["timestamp"] = timestamp
        let sort = dic.sorted { d1, d2 in
            d1.key < d2.key
        }
        return sort.reduce("", { partialResult, item in
            var res = partialResult
            res += "\(item.key)=\(item.value)"
            return res
        })
    }
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
        var headers : HTTPHeaders = headers ?? [:]
        let nonce = "sdsdsd"
        let timestamp =  "\(Int(Date().timeIntervalSince1970))"
        let signClient = self.signature(data: parameters!, nonce: nonce, timestamp: timestamp).hmacSHA512(key: "SIGNATURE_KEY_SECRECT") ?? ""
        headers.add(name: "X-Auth-Signature", value: signClient)
        headers.add(name: "X-Auth-Nonce", value: nonce)
        headers.add(name: "X-Auth-Timestamp", value: timestamp)
        if let auth = self.authorization {
            headers.add(name: "authorization", value: "Bearer \(auth.token)")
        }
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
                    print(error)
                    return Observable.error(ParseDataError(parseClass: String(describing: O.self), errorMessage: error.localizedDescription))
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
