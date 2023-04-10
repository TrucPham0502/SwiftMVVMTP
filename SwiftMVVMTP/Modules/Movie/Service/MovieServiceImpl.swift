//
//  MovieServiceImpl.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxSwift
class MovieServiceImpl : MovieService {
    @Dependency.Inject
    var repository : MovieRepository
    
    func searchMovies(_ input: SearchMoviesRequest) -> Observable<HomeModel> {
        return repository.searchMovies(input).flatMap({ response -> Observable<HomeModel> in
            let films = response.map({d in
                d.data.map{v in
                    v.map({
                        MovieCollectionViewCellModel(url: $0.url ?? "", name: $0.name ?? "", poster: $0.poster ?? "", tag: $0.picTag ?? "", episode: $0.episode ?? "", isBookmark: false)
                    })
                } ?? []
            })
            let titlesItem = response.map({
                MovieCategory(nextPage: $0.nextPage ?? -1, title: $0.title ?? "", type: $0.pageType ?? "")
            })
            return Observable.just(HomeModel(titles: titlesItem, datas: films))
        })
    }
    
    
    func getMovies(_ input: MoviesRequest) -> Observable<HomeModel> {
        return repository.getMovies(input).flatMap({ response -> Observable<HomeModel> in
            let films = response.map({d in
                d.data.map{v in
                    v.map({
                        MovieCollectionViewCellModel(url: $0.url ?? "", name: $0.name ?? "", poster: $0.poster ?? "", tag: $0.picTag ?? "", episode: $0.episode ?? "", isBookmark: false)
                    })
                } ?? []
            })
            let titlesItem = response.map({
                MovieCategory(nextPage: $0.nextPage ?? -1, title: $0.title ?? "", type: $0.pageType ?? "")
            })
            return Observable.just(HomeModel(titles: titlesItem, datas: films))
        })
    }
    
 
    
    
    func getMoviesByGroup(_ input: MoviesRequest) -> Observable<(page : Int, data: [MovieCollectionViewCellModel])> {
        return repository.getMovies(input).flatMap({ response -> Observable<(page : Int, data: [MovieCollectionViewCellModel])> in
            let films = response.map({d in
                d.data.map{v in
                    v.map({
                        MovieCollectionViewCellModel(url: $0.url ?? "", name: $0.name ?? "", poster: $0.poster ?? "", tag: $0.picTag ?? "", episode: $0.episode ?? "", isBookmark: false)
                    })
                } ?? []
            }).first ?? []
            return Observable.just((response.first?.nextPage ?? -1,films))
        })
    }
    
    func movieDetail(_ input : MovieDetailRequest) -> Observable<MovieDetailModel> {
        return repository.movieDetail(input).map({ res in
            let eps : [EpisodeModel] = res.episodes?.compactMap({ d -> EpisodeModel? in
                return EpisodeModel(episode: d.episode ?? "", url: d.url ?? "")
            }).reversed() ?? []
            let content : String = res.contents?.joined(separator: "\n")  ?? ""
            let category : String = res.categorys?.joined(separator: ", ") ?? ""
            return MovieDetailModel(title: res.title ?? "", episodes: eps, content: content, time: res.time ?? "", season: res.season ?? "", latest: res.latest ?? "", categorys: category)
        })
    }
    
    func getPlayInfo(_ url : String) -> Observable<PlayerModel> {
        return repository.getPlayInfo(.init(url: url)).map({x in
            let type = PlayerModel.Media.MediaType(rawValue: (x.media?.type?.rawValue ?? "default"))!
            
            
            return .init(media: .init(url: x.media?.url ?? "", type: type), sublinks: x.sublinks?.map({ l in
                return PlayerModel.Sublink(subsv: l.subsv ?? "", name: l.name ?? "")
            }) ?? [])
        })
    }
    
    func signIn(_ input : SignInRequest) -> Observable<()> {
        return repository.signIn(input).mapToVoid()
    }
}
