//
//  TestModuleService.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 24/09/2021.
//

import Foundation
import RxSwift
class TestModuleServiceImpl : TestModuleService {
    @Dependency.Inject
    var repository : TestModuleRepository
    func getDataTest(_ input: DataTestRequest) -> Observable<[TestCellModel]> {
        repository.getDataTest(input).map({
            $0.map({ d in
                TestCellModel(content: d.content)
            })
        })
    }
    
    
}
