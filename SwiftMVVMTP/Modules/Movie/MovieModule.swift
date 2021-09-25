//
//  MovieModule.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
class MovieModule : Dependency.Module {
    override func register(_ dependency: Dependency) {
        dependency.register(MovieRemoteSource.self, service: MovieRemoteSourceImpl.self)
        dependency.register(MovieRepository.self, service: MovieRepositoryImpl.self)
        dependency.register(MovieService.self, service: MovieServiceImpl.self)
    }
}
