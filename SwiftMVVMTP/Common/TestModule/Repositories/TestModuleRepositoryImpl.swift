//
//  TestModuleRepositoryImpl.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 24/09/2021.
//

import Foundation
import RxSwift
class TestModuleRepositoryImpl : NSObject, TestModuleRepository {
    @Dependency.Get
    var repository : TestModuleRemoteSource
    func getDataTest(_ input: DataTestRequest) -> Observable<[DataTestResponse]> {
        repository.getDataTest(input).flatMap({ d -> Observable<[DataTestResponse]>  in
            if d.returnCode == .success {
                return Observable.just(d.data ?? [])
            }
            return Observable.error(ApiError(parseClass: String(describing: self), errorMessage: d.returnMessage, errorCode: d.returnCode?.rawValue))
        })
    }
}
