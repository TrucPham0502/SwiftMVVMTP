//
//  MovieService.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxSwift
protocol MovieService {
    func getMovies(_ input : MoviesRequest) ->  Observable<(titleData: [MovieCategory], data: [[MovieCollectionViewCellModel]])>
    func searchMovies(_ input : SearchMoviesRequest) ->  Observable<(titleData: [MovieCategory], data: [[MovieCollectionViewCellModel]])>
    func movieDetail(_ input : MovieDetailRequest) -> Observable<([EpisodeModel], content: String, time: String, season: String, latest: String, categorys : String)>
    func getMoviesByGroup(_ input : MoviesRequest) -> Observable<(page : Int, data: [MovieCollectionViewCellModel])>
    
    func getLinkAndSublink(_ url : String) -> Observable<PlayerModel>
    
    
 
//    func dailymotionM3u8(_ url : String) ->  Observable<[Any]>
//    func fileOneData(_ input: FileOneRequest) -> Observable<FileOneResponse?>
//    func fembedData(_ id: String) -> Observable<[FembedResponse]>
//    func hhtqEpisode(_ input : HHTQEpisodeRequest) -> Observable<HHTQEpisodeResponse?>
   
//    func getEpisodeDetail(_ input : EpisodeDetailRequest) -> Observable<EpisodeDetailResponse?>
}
