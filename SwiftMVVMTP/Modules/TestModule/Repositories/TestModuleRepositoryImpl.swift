//
//  TestModuleRepositoryImpl.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 24/09/2021.
//

import Foundation
import RxSwift
class TestModuleRepositoryImpl : TestModuleRepository {
    @Dependency.Inject
    var repository : TestModuleRemoteSource
    func getDataTest(_ input: DataTestRequest) -> Observable<[DataTestResponse]> {
        repository.getDataTest(input).flatMap({ d -> Observable<[DataTestResponse]>  in
            if d.status == .success {
                return Observable.just(d.data!)
            }
            return Observable.error(ApiError(parseClass: String(describing: self), errorMessage: d.message, errorCode: d.status.rawValue))
        })
    }
}
