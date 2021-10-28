//
//  MovieRemoteSource.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxSwift
protocol MovieRemoteSource {
    func getMovieHome(_ input : MovieHomeRequest, pageType : PageType) -> Observable<ApiResponseDto<[MovieHomeResponse]>>
    func dailymotionM3u8(_ id : String) ->  Observable<ApiResponseDto<String>>
    func fileOneData(_ input: FileOneRequest) -> Observable<ApiResponseDto<FileOneResponse>>
    func fembedData(_ id: String) -> Observable<ApiResponseDto<[FembedResponse]>>
    func hhtqEpisode(_ input : HHTQEpisodeRequest) -> Observable<ApiResponseDto<HHTQEpisodeResponse>>
    func movieDetail(_ input : MovieDetailRequest, pageType : PageType) -> Observable<ApiResponseDto<MovieDetailResponse>>
    
}

