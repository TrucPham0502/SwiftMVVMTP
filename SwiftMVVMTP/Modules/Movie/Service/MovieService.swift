//
//  MovieService.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxSwift
protocol MovieService {
    func getMovies(_ input : MoviesRequest) ->  Observable<HomeModel>
    func searchMovies(_ input : SearchMoviesRequest) ->  Observable<HomeModel>
    func movieDetail(_ input : MovieDetailRequest) -> Observable<MovieDetailModel>
    func getMoviesByGroup(_ input : MoviesRequest) -> Observable<(page : Int, data: [MovieCollectionViewCellModel])>
    
    func getPlayInfo(_ url : String) -> Observable<PlayerModel>
    
    
 
//    func dailymotionM3u8(_ url : String) ->  Observable<[Any]>
//    func fileOneData(_ input: FileOneRequest) -> Observable<FileOneResponse?>
//    func fembedData(_ id: String) -> Observable<[FembedResponse]>
//    func hhtqEpisode(_ input : HHTQEpisodeRequest) -> Observable<HHTQEpisodeResponse?>
   
//    func getEpisodeDetail(_ input : EpisodeDetailRequest) -> Observable<EpisodeDetailResponse?>
}
