//
//  TestModule.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
class TestModule : Dependency.Module {
    override func register(_ dependency: Dependency) {
        dependency.register(TestModuleService.self, service: TestModuleServiceImpl.self)
        dependency.register(TestModuleRepository.self, service: TestModuleRepositoryImpl.self)
        dependency.register(TestModuleRemoteSource.self, service: TestModuleRemoteSourceImpl.self)
    }
}
