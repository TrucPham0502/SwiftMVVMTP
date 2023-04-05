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
    
    
    
    @GET<String>
    func dailymotionM3u8(_ url : String) ->  Observable<ApiResponseDto<String>> {
        ApiParameter.url(endpoint: url, path: "")
    }
    
    @POST<EpisodeDetailResponse>
    func getEpisodeDetail(_ input : EpisodeDetailRequest) -> Observable<ApiResponseDto<EpisodeDetailResponse>> {
        ApiParameter.url(endpoint: host, path: "movie/episode")
        ApiParameter.parameter(input)
    }
    
//    @POST<FileOneResponse>
//    func fileOneData(_ input: FileOneRequest) -> Observable<ApiResponseDto<FileOneResponse>> {
//        ApiParameter.url(endpoint: host, path: "fileone")
//        ApiParameter.parameter(input)
//    }
//
//    @POST<[FembedResponse]>
//    func fembedData(_ id: String) -> Observable<ApiResponseDto<[FembedResponse]>>{
//        ApiParameter.url(endpoint: host, path: (String(format: "fembed?id=%@", id)))
//    }
//
//    @POST<HHTQEpisodeResponse>
//    func hhtqEpisode(_ input : HHTQEpisodeRequest) -> Observable<ApiResponseDto<HHTQEpisodeResponse>> {
//        ApiParameter.url(endpoint: host, path: "hhtq/getepisode")
//        ApiParameter.parameter(input)
//    }
//
  
}
