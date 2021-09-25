//
//  MovieRepository.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxSwift
protocol MovieRepository {
    func getMovieHome(_ input : MovieHomeRequest,  pageType : PageType) -> Observable<[MovieHomeResponse]>
    func dailymotionM3u8(_ id : String) ->  Observable<[Any]>
    func fileOneData(_ input: FileOneRequest) -> Observable<FileOneResponse?>
    func fembedData(_ id: String) -> Observable<[FembedResponse]>
    func hhtqEpisode(_ input : HHTQEpisodeRequest) -> Observable<HHTQEpisodeResponse?>
    func movieDetail(_ input : MovieDetailRequest, pageType : PageType) -> Observable<MovieDetailResponse?>
}
extension MovieRepository {
    func getMovieHome(_ input : MovieHomeRequest) -> Observable<[MovieHomeResponse]> {
        return getMovieHome(input, pageType: .unknown)
    }
}
