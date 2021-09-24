//
//  TestModuleRemoteSourceImpl.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 24/09/2021.
//

import Foundation
import RxSwift
class TestModuleRemoteSourceImpl : NSObject, TestModuleRemoteSource {
    
    func getDataTest(_ input: DataTestRequest) -> Observable<ApiResponseDto<[DataTestResponse]>> {
        @ApiMethod.Post(Constants.host, parameters: input)
        var data : Observable<ApiResponseDto<[DataTestResponse]>>
        return data
    }
}
