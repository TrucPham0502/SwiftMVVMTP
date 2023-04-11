//
//  MovieRemoteSource.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxSwift
protocol MovieRemoteSource {
    func getMovies(_ input : MoviesRequest) -> Observable<ApiResponseDto<[MoviesResponse]>>
    func searchMovies(_ input : SearchMoviesRequest) -> Observable<ApiResponseDto<[MoviesResponse]>>
    func movieDetail(_ input : MovieDetailRequest) -> Observable<ApiResponseDto<MovieDetailResponse>>
    func getPlayInfo(_ input : PlayInfoRequest) -> Observable<ApiResponseDto<PlayInfoResponse>>
    
    func signIn(_ input : SignInRequest) -> Observable<ApiResponseDto<SignInResponse>>
    
    func setBookmark(_ input : SetBookmarkRequest) -> Observable<ApiResponseDto<Nothing>>
    func removeBookmark(_ input : RemoveBookmarkRequest) -> Observable<ApiResponseDto<Nothing>>
    
}

