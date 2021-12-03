//
//  MovieModule.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
class MovieModule : Module {
    func register(_ dependency: Dependency) {
        dependency.register(MovieRemoteSource.self) { MovieRemoteSourceImpl() }
        dependency.register(MovieRepository.self){ MovieRepositoryImpl() }
        dependency.register(MovieService.self){ MovieServiceImpl() }
    }
}
