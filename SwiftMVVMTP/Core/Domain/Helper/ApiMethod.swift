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
        var projectedValue: Post<T> {
            return self
        }
    }
    @propertyWrapper
    struct Get<T : Codable>  {
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
        var projectedValue: Get<T> {
            return self
        }
    }
    
}

enum ApiParameter {
    case url(endpoint: String, path: String)
    case parameter(Codable)
}

struct Nothing: Codable, Hashable {
    init() {}
    static var nothing: Nothing { return .init() }
}

@resultBuilder
struct POST<T : Codable> {
    static func buildBlock(_ paramters: ApiParameter...) -> Observable<ApiResponseDto<T>> {
        var url = ""
        var paramter : Codable = Nothing.nothing
        paramters.forEach({
            switch $0 {
            case .url(let endpoint, let path):
                url = "\(endpoint)\(path)"
            case .parameter(let d):
                paramter = d
            }
        })
        @ApiMethod.Post(url, parameters: paramter)
        var data : Observable<ApiResponseDto<T>>
        return data
    }
}

@resultBuilder
struct GET<T : Codable> {
    static func buildBlock(_ paramters: ApiParameter...) -> Observable<ApiResponseDto<T>> {
        var url = ""
        var paramter : Codable = Nothing.nothing
        paramters.forEach({
            switch $0 {
            case .url(let endpoint, let path):
                url = "\(endpoint)\(path)"
            case .parameter(let d):
                paramter = d
            }
        })
        @ApiMethod.Get(url, parameters: paramter)
        var data : Observable<ApiResponseDto<T>>
        return data
    }
}

