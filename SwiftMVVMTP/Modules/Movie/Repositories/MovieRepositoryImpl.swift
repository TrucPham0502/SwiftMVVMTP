//
//  MovieRepositoryImpl.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxSwift
class MovieRepositoryImpl : BaseRepository , MovieRepository {
    func getPlayInfo(_ input: PlayInfoRequest) -> Observable<PlayInfoResponse> {
        return remoteSource.getPlayInfo(input).valid()
    }
    
    @Dependency.Inject
    var remoteSource : MovieRemoteSource
    
    func getMovies(_ input: MoviesRequest) -> Observable<[MoviesResponse]> {
        return remoteSource.getMovies(input).valid()
    }
    
    func searchMovies(_ input: SearchMoviesRequest) -> Observable<[MoviesResponse]> {
        return remoteSource.searchMovies(input).valid()
    }
    
    func movieDetail(_ input : MovieDetailRequest) -> Observable<MovieDetailResponse> {
        return remoteSource.movieDetail(input).valid()
    }
    
    func signIn(_ input : SignInRequest) -> Observable<SignInResponse> {
        return remoteSource.signIn(input).valid().do(onNext: {data in
            
        })
    }
}
