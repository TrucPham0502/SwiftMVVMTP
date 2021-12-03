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
    
    @POST<[MovieHomeResponse]>
    func getMovieHome(_ input: MovieHomeRequest, pageType : PageType) -> Observable<ApiResponseDto<[MovieHomeResponse]>> {
        ApiParameter.url("\(host)\(pageType.rawValue)/list")
        ApiParameter.parameter(input)
    }
    
    
    @GET<String>
    func dailymotionM3u8(_ id : String) ->  Observable<ApiResponseDto<String>> {
        ApiParameter.url(String(format: "\(host)dailymotion?id=%@", id))
    }
    
    @POST<FileOneResponse>
    func fileOneData(_ input: FileOneRequest) -> Observable<ApiResponseDto<FileOneResponse>> {
        ApiParameter.url("\(host)fileone")
        ApiParameter.parameter(input)
    }
    
    @POST<[FembedResponse]>
    func fembedData(_ id: String) -> Observable<ApiResponseDto<[FembedResponse]>>{
        ApiParameter.url(String(format: "\(host)fembed?id=%@", id))
    }
    
    @POST<HHTQEpisodeResponse>
    func hhtqEpisode(_ input : HHTQEpisodeRequest) -> Observable<ApiResponseDto<HHTQEpisodeResponse>> {
        ApiParameter.url("\(host)hhtq/getepisode")
        ApiParameter.parameter(input)
    }
    
    @POST<MovieDetailResponse>
    func movieDetail(_ input : MovieDetailRequest, pageType : PageType) -> Observable<ApiResponseDto<MovieDetailResponse>> {
        ApiParameter.url("\(host)\(pageType.rawValue)/detail")
        ApiParameter.parameter(input)
    }
}
