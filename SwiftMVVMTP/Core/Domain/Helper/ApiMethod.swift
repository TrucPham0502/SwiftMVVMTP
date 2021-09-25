//
//  ApiRequest.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import Foundation
import Alamofire
import RxSwift
struct ApiMethod {
    @propertyWrapper
    struct Post<T : Codable> {
        let url : String
        let header : HTTPHeaders? = nil
        let encoding: ParameterEncoding = URLEncoding.default
        var parameters: Encodable?
        var wrappedValue : Observable<ApiResponseDto<T>> {
            return ApiRequestManager<T>().request(.post, url, parameters: parameters, headers: header)
        }
        init(_ url : String, parameters: Encodable) {
            self.url = url
            self.parameters = parameters
        }
        init(_ url : String) {
            self.url = url
            self.parameters = nil
        }
        
    }
    @propertyWrapper
    struct Get<T : Codable> {
        let url : String
        let header : HTTPHeaders? = nil
        let encoding: ParameterEncoding = URLEncoding.default
        var parameters: Encodable?
        var wrappedValue : Observable<ApiResponseDto<T>> {
            return ApiRequestManager<T>().request(.get, url, parameters: parameters, headers: header)
        }
        init(_ url : String, parameters: Encodable) {
            self.url = url
            self.parameters = parameters
        }
        init(_ url : String) {
            self.url = url
            self.parameters = nil
        }
    }

}

