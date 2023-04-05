//
//  MovieRepository.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxSwift
protocol MovieRepository {
    func getMovies(_ input : MoviesRequest) -> Observable<[MoviesResponse]>
    func searchMovies(_ input : SearchMoviesRequest) -> Observable<[MoviesResponse]>
    func movieDetail(_ input : MovieDetailRequest) -> Observable<MovieDetailResponse>
    func getLinkAndSublink(_ input : LinkAndSublinkRequest) -> Observable<LinkAndSublinkResponse>
    
    
//    func dailymotionM3u8(_ url : String) ->  Observable<[Any]>
//    func fileOneData(_ input: FileOneRequest) -> Observable<FileOneResponse?>
//    func fembedData(_ id: String) -> Observable<[FembedResponse]>
//    func hhtqEpisode(_ input : HHTQEpisodeRequest) -> Observable<HHTQEpisodeResponse?>
    
//    func getEpisodeDetail(_ input : EpisodeDetailRequest) -> Observable<EpisodeDetailResponse?>
}
