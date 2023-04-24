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
    
    func getPlayInfo(_ url : String, sublink : String?) -> Observable<PlayerModel>
    func signIn(_ input : SignInRequest) -> Observable<()>
    
 
    func setBookmark(_ input : SetBookmarkRequest) -> Observable<Void>
    func removeBookmark(_ input : RemoveBookmarkRequest) -> Observable<Void>
    
    
    
}

extension MovieService {
    func getPlayInfo(_ url : String) -> Observable<PlayerModel> {
        return getPlayInfo(url, sublink: nil)
    }
}
