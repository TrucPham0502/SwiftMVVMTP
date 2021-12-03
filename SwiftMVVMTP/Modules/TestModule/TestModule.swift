//
//  TestModule.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
class TestModule : Module {
    func register(_ dependency: Dependency) {
        dependency.register(TestModuleService.self) { TestModuleServiceImpl() }
        dependency.register(TestModuleRepository.self) { TestModuleRepositoryImpl() }
        dependency.register(TestModuleRemoteSource.self) { TestModuleRemoteSourceImpl() }
    }
}
