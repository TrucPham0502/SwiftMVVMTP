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
    
    func searchMovies(_ input: SearchMoviesRequest) -> Observable<(titleData: [MovieCategory], data: [[MovieCollectionViewCellModel]])> {
        return repository.searchMovies(input).flatMap({ response -> Observable<(titleData: [MovieCategory], data: [[MovieCollectionViewCellModel]])> in
            let films = response.map({d in
                d.data.map{v in
                    v.map({
                        MovieCollectionViewCellModel(url: $0.url ?? "", name: $0.name ?? "", poster: $0.poster ?? "", tag: $0.picTag?.rawValue ?? "", episode: $0.episode ?? "")
                    })
                } ?? []
            })
            let titlesItem = response.map({
                MovieCategory(nextPage: $0.nextPage ?? -1, title: $0.title ?? "")
            })
            return Observable.just((titlesItem, films))
        })
    }
    
    
    func getMovies(_ input: MoviesRequest) -> Observable<(titleData: [MovieCategory], data: [[MovieCollectionViewCellModel]])> {
        return repository.getMovies(input).flatMap({ response -> Observable<(titleData: [MovieCategory], data: [[MovieCollectionViewCellModel]])> in
            let films = response.map({d in
                d.data.map{v in
                    v.map({
                        MovieCollectionViewCellModel(url: $0.url ?? "", name: $0.name ?? "", poster: $0.poster ?? "", tag: $0.picTag?.rawValue ?? "", episode: $0.episode ?? "")
                    })
                } ?? []
            })
            let titlesItem = response.map({
                MovieCategory(nextPage: $0.nextPage ?? -1, title: $0.title ?? "")
            })
            return Observable.just((titlesItem, films))
        })
    }
    
 
    
    
    func getMoviesByGroup(_ input: MoviesRequest) -> Observable<(page : Int, data: [MovieCollectionViewCellModel])> {
        return repository.getMovies(input).flatMap({ response -> Observable<(page : Int, data: [MovieCollectionViewCellModel])> in
            let films = response.map({d in
                d.data.map{v in
                    v.map({
                        MovieCollectionViewCellModel(url: $0.url ?? "", name: $0.name ?? "", poster: $0.poster ?? "", tag: $0.picTag?.rawValue ?? "", episode: $0.episode ?? "")
                    })
                } ?? []
            }).first ?? []
            return Observable.just((response.first?.nextPage ?? -1,films))
        })
    }
    
    func movieDetail(_ input : MovieDetailRequest) -> Observable<([EpisodeModel], content: String, time: String, season: String, latest: String, categorys : String)> {
        return repository.movieDetail(input).map({ res in
            let eps : [EpisodeModel] = res.episodes?.compactMap({ d -> EpisodeModel? in
                return EpisodeModel(dataPostID: d.dataPostId ?? "", dataServer: d.dataServer ?? "", dataEpisodeSlug: d.dataEpisodeSlug ?? "", isNew: d.isNew ?? false, dataEmbed: d.dataEmbed ?? "", episode: d.episode ?? "", url: d.url ?? "")
            }).reversed() ?? []
            let content : String = res.contents?.joined(separator: "\n")  ?? ""
            let category : String = res.categorys?.joined(separator: ", ") ?? ""
            return (eps, content, res.time ?? "", res.season ?? "", res.latest ?? "", category)
        })
    }
    
    func getLinkAndSublink(_ url : String) -> Observable<PlayerModel> {
        return repository.getLinkAndSublink(.init(url: url)).map({x in
            return .init(media: .init(url: x.media?.url ?? "", type: x.media?.type ?? ""), sublinks: x.sublinks?.map({ l in
                return PlayerModel.Sublink(subsv: l.subsv ?? "", name: l.name ?? "")
            }) ?? [])
        })
    }
    
//    func dailymotionM3u8(_ url : String) ->  Observable<[Any]> {
//        return repository.dailymotionM3u8(url)
//    }
//    func fileOneData(_ input: FileOneRequest) -> Observable<FileOneResponse?> {
//        return repository.fileOneData(input)
//    }
//    func fembedData(_ id: String) -> Observable<[FembedResponse]> {
//        return repository.fembedData(id)
//    }
//    func hhtqEpisode(_ input : HHTQEpisodeRequest) -> Observable<HHTQEpisodeResponse?>  {
//        return repository.hhtqEpisode(input)
//    }
    
//    func getEpisodeDetail(_ input : EpisodeDetailRequest) -> Observable<EpisodeDetailResponse?> {
//        return repository.getEpisodeDetail(input)
//    }
}
