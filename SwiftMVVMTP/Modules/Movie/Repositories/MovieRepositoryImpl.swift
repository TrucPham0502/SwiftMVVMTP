//
//  MovieRepositoryImpl.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxSwift
class MovieRepositoryImpl : BaseRepository , MovieRepository {
    func getPlayInfo(_ input: PlayInfoRequest) -> Observable<PlayInfoResponse> {
        return remoteSource.getPlayInfo(input).valid().flatMap { res -> Observable<PlayInfoResponse> in
            if res.media?.type == .client, let urlString = res.media?.url, let url = URL(string: urlString) {
                return url.getContent.flatMap {[unowned self] body -> Observable<PlayInfoResponse> in
                    return self.remoteSource.processData(.init(type: input.url, url: urlString, body: body)).valid().map({url in
                        var _res = res
                        _res.media?.url = url
                        _res.media?.type = .m3u8
                        return _res
                    })
                }
            }
            return Observable.just(res)
        }
    }
    
    @Dependency.Inject
    var remoteSource : MovieRemoteSource
    
    func getMovies(_ input: MoviesRequest) -> Observable<[MoviesResponse]> {
        return remoteSource.getMovies(input).valid()
    }
    
    func searchMovies(_ input: SearchMoviesRequest) -> Observable<[MoviesResponse]> {
        return remoteSource.searchMovies(input).valid()
    }
    
    func movieDetail(_ input : MovieDetailRequest) -> Observable<MovieDetailResponse> {
        return remoteSource.movieDetail(input).valid()
    }
    
    func signIn(_ input : SignInRequest) -> Observable<SignInResponse> {
        return remoteSource.signIn(input).valid().do(onNext: {data in
            guard let token = data.token, let user = data.user else { return }
            AppData.saveDataUser(user: user, author: Authorization(token: token, refreshToken: data.refreshToken ?? "", privateKey: data.privateKey ?? ""))
            
        })
    }
    
    
    
    func setBookmark(_ input : SetBookmarkRequest) -> Observable<Void> {
        return remoteSource.setBookmark(input).valid().mapToVoid()
    }
    
    func removeBookmark(_ input : RemoveBookmarkRequest) -> Observable<Void> {
        return remoteSource.removeBookmark(input).valid().mapToVoid()
    }
}
