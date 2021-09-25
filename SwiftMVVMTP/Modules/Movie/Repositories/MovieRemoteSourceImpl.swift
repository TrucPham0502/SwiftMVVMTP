//
//  MovieRemoteSourceImpl.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxSwift
class MovieRemoteSourceImpl : NSObject, MovieRemoteSource {
    let host = Constants.appEndPointUrl + "api/"
    func getMovieHome(_ input: MovieHomeRequest, pageType : PageType) -> Observable<ApiResponseDto<[MovieHomeResponse]>> {
        @ApiMethod.Post("\(host)\(pageType.rawValue)/list", parameters: input)
        var data : Observable<ApiResponseDto<[MovieHomeResponse]>>
        return data
    }
    
    func dailymotionM3u8(_ id : String) ->  Observable<ApiResponseDto<String>> {
        @ApiMethod.Get(String(format: "\(host)dailymotion?id=%@", id))
        var dataM3u8 : Observable<ApiResponseDto<String>>
        return dataM3u8
    }
    
    func fileOneData(_ input: FileOneRequest) -> Observable<ApiResponseDto<FileOneResponse>> {
        @ApiMethod.Post("\(host)fileone", parameters: input)
        var data : Observable<ApiResponseDto<FileOneResponse>>
        return data
    }
    
    func fembedData(_ id: String) -> Observable<ApiResponseDto<[FembedResponse]>>{
        @ApiMethod.Post(String(format: "\(host)fembed?id=%@", id))
        var data :Observable<ApiResponseDto<[FembedResponse]>>
        return data
    }
    func hhtqEpisode(_ input : HHTQEpisodeRequest) -> Observable<ApiResponseDto<HHTQEpisodeResponse>> {
        @ApiMethod.Post("\(Constants.appEndPointUrl)hhtq/getepisode", parameters: input)
        var data : Observable<ApiResponseDto<HHTQEpisodeResponse>>
        return data
    }
    func movieDetail(_ input : MovieDetailRequest, pageType : PageType) -> Observable<ApiResponseDto<MovieDetailResponse>> {
        @ApiMethod.Post("\(host)\(pageType.rawValue)/detail", parameters: input)
        var data :  Observable<ApiResponseDto<MovieDetailResponse>>
        return data
    }
}
