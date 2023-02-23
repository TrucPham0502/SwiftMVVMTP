//
//  TestModuleRemoteSourceImpl.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 24/09/2021.
//

import Foundation
import RxSwift
class TestModuleRemoteSourceImpl : TestModuleRemoteSource {
    
    @POST<[DataTestResponse]>
    func getDataTest(_ input: DataTestRequest) -> Observable<ApiResponseDto<[DataTestResponse]>> {
        ApiParameter.url(endpoint: "", path: "Constants.host")
        ApiParameter.parameter(input)
    }
}
