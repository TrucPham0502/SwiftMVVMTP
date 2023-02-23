//
//  MovieRepository.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxSwift
protocol MovieRepository {
    func getMovieHome(_ input : MovieHomeRequest) -> Observable<[MovieHomeResponse]>
    func dailymotionM3u8(_ url : String) ->  Observable<[Any]>
//    func fileOneData(_ input: FileOneRequest) -> Observable<FileOneResponse?>
//    func fembedData(_ id: String) -> Observable<[FembedResponse]>
//    func hhtqEpisode(_ input : HHTQEpisodeRequest) -> Observable<HHTQEpisodeResponse?>
    func movieDetail(_ input : MovieDetailRequest) -> Observable<MovieDetailResponse?>
    func getEpisodeDetail(_ input : EpisodeDetailRequest) -> Observable<EpisodeDetailResponse?>
}
