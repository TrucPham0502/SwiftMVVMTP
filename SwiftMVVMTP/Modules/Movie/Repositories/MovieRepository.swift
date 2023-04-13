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
    func getPlayInfo(_ input : PlayInfoRequest) -> Observable<PlayInfoResponse>
    func signIn(_ input : SignInRequest) -> Observable<SignInResponse>
    
    func setBookmark(_ input : SetBookmarkRequest) -> Observable<Void>
    func removeBookmark(_ input : RemoveBookmarkRequest) -> Observable<Void>
    func logout()
}
