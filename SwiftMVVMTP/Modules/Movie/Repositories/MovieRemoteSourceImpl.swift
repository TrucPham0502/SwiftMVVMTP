//
//  MovieRemoteSourceImpl.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxSwift

class MovieRemoteSourceImpl : MovieRemoteSource {
    
    let host = Constants.appEndPointUrl + "api/"
    
    @POST<PlayInfoResponse>
    func getPlayInfo(_ input : PlayInfoRequest) -> Observable<ApiResponseDto<PlayInfoResponse>> {
        ApiParameter.url(endpoint: host, path: "movie/getPlayInfo")
        ApiParameter.parameter(input)
    }
    
    @POST<[MoviesResponse]>
    func getMovies(_ input: MoviesRequest) -> Observable<ApiResponseDto<[MoviesResponse]>> {
        ApiParameter.url(endpoint: host, path: "movie/list")
        ApiParameter.parameter(input)
    }
    
    @POST<[MoviesResponse]>
    func searchMovies(_ input : SearchMoviesRequest) -> Observable<ApiResponseDto<[MoviesResponse]>> {
        ApiParameter.url(endpoint: host, path: "movie/search")
        ApiParameter.parameter(input)
    }
    
    @POST<MovieDetailResponse>
    func movieDetail(_ input : MovieDetailRequest) -> Observable<ApiResponseDto<MovieDetailResponse>> {
        ApiParameter.url(endpoint: host, path: "movie/detail")
        ApiParameter.parameter(input)
    }
    
    @POST<SignInResponse>
    func signIn(_ input : SignInRequest) -> Observable<ApiResponseDto<SignInResponse>> {
        ApiParameter.url(endpoint: host, path: "/login")
        ApiParameter.parameter(input)
    }
    

  
}
