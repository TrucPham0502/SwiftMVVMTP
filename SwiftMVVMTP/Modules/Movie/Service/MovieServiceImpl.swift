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
    func getMovieHome(_ input: MovieHomeRequest) -> Observable<([MovieCategory], [[MovieCollectionViewCellModel]])> {
        return repository.getMovieHome(input).flatMap({ response -> Observable<([MovieCategory], [[MovieCollectionViewCellModel]])> in
            let films = response.map({d in
                d.data.map{v in
                    v.map({
                        MovieCollectionViewCellModel(url: $0.url, name: $0.name, poster: $0.poster, tag: $0.picTag)
                    })
                } ?? []
            })
            let titlesItem = response.map({
                MovieCategory(urlPage: $0.urlPage, title: $0.title, pageType: $0.pageType)
            })
            return Observable.just((titlesItem, films))
        })
    }
    
    func movieLoadMore(_ input: MovieHomeRequest) -> Observable<[MovieCollectionViewCellModel]> {
        return repository.getMovieHome(input, pageType: .hhkungfu).flatMap({ response -> Observable<[MovieCollectionViewCellModel]> in
            let films = response.map({d in
                d.data.map{v in
                    v.map({
                        MovieCollectionViewCellModel(url: $0.url, name: $0.name, poster: $0.poster, tag: $0.picTag)
                    })
                } ?? []
            }).first ?? []
            return Observable.just(films)
        })
    }
    
    func dailymotionM3u8(_ id : String) ->  Observable<[Any]> {
        return repository.dailymotionM3u8(id)
    }
    func fileOneData(_ input: FileOneRequest) -> Observable<FileOneResponse?> {
        return repository.fileOneData(input)
    }
    func fembedData(_ id: String) -> Observable<[FembedResponse]> {
        return repository.fembedData(id)
    }
    func hhtqEpisode(_ input : HHTQEpisodeRequest) -> Observable<HHTQEpisodeResponse?>  {
        return repository.hhtqEpisode(input)
    }
    func movieDetail(_ input : MovieDetailRequest, pageType : PageType) -> Observable<([EpisodeModel], String)> {
        return repository.movieDetail(input, pageType: pageType).map({ res in
            let ep : [EpisodeModel] = {
                return res?.episodes?.compactMap({ d -> EpisodeModel? in
                    return EpisodeModel(episode: d.episode, id: d.id, link: d.link, isNew: d.isNew, type: d.type)
                }).reversed() ?? []
            }()
            let content : String = {
                return res?.contents?.reduce("") { res, str in
                    let result = res ?? ""
                    let val = str.isEmpty ? "" : " \(str)"
                    return result.isEmpty ? str : "\(result)\n\(val)"
                } ?? ""
            }()
            return (ep, content)
        })
    }
}
