//
//  TestModuleRepository.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 24/09/2021.
//

import Foundation
import RxSwift
protocol TestModuleRepository {
    func getDataTest(_ input : DataTestRequest) -> Observable<[DataTestResponse]>
}
