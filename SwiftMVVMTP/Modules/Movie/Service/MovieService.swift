//
//  MovieService.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxSwift
protocol MovieService {
    func getMovieHome(_ input : MovieHomeRequest) ->  Observable<([MovieCategory], [[MovieCollectionViewCellModel]])>
    func movieLoadMore(_ input : MovieHomeRequest) -> Observable<[MovieCollectionViewCellModel]>
    func dailymotionM3u8(_ id : String) ->  Observable<[Any]>
    func fileOneData(_ input: FileOneRequest) -> Observable<FileOneResponse?>
    func fembedData(_ id: String) -> Observable<[FembedResponse]>
    func hhtqEpisode(_ input : HHTQEpisodeRequest) -> Observable<HHTQEpisodeResponse?>
    func movieDetail(_ input : MovieDetailRequest, pageType : PageType) -> Observable<([EpisodeModel], String)>
}
extension MovieService {
    func movieDetail(_ input : MovieDetailRequest) -> Observable<([EpisodeModel], String)> {
        return self.movieDetail(input, pageType: .unknown)
    }
}
