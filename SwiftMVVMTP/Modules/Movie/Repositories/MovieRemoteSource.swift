//
//  MovieRemoteSource.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxSwift
protocol MovieRemoteSource {
    func getMovieHome(_ input : MovieHomeRequest) -> Observable<ApiResponseDto<[MovieHomeResponse]>>
    func dailymotionM3u8(_ url : String) ->  Observable<ApiResponseDto<String>>
//    func fileOneData(_ input: FileOneRequest) -> Observable<ApiResponseDto<FileOneResponse>>
//    func fembedData(_ id: String) -> Observable<ApiResponseDto<[FembedResponse]>>
//    func hhtqEpisode(_ input : HHTQEpisodeRequest) -> Observable<ApiResponseDto<HHTQEpisodeResponse>>
    func movieDetail(_ input : MovieDetailRequest) -> Observable<ApiResponseDto<MovieDetailResponse>>
    func getEpisodeDetail(_ input : EpisodeDetailRequest) -> Observable<ApiResponseDto<EpisodeDetailResponse>>
    
}

