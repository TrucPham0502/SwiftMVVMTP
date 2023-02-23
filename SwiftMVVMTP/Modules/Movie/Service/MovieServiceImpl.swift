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
    func getMovieHome(_ input: MovieHomeRequest) -> Observable<(titleData: [MovieCategory], data: [[MovieCollectionViewCellModel]])> {
        return repository.getMovieHome(input).flatMap({ response -> Observable<(titleData: [MovieCategory], data: [[MovieCollectionViewCellModel]])> in
            let films = response.map({d in
                d.data.map{v in
                    v.map({
                        MovieCollectionViewCellModel(url: $0.url, name: $0.name, poster: $0.poster, tag: $0.picTag?.rawValue)
                    })
                } ?? []
            })
            let titlesItem = response.map({
                MovieCategory(nextPage: $0.nextPage ?? -1, title: $0.title ?? "", pageType: $0.pageType ?? .unknown)
            })
            return Observable.just((titlesItem, films))
        })
    }
    
    func movieLoadMore(_ input: MovieHomeRequest) -> Observable<(pageNumber : Int, data: [MovieCollectionViewCellModel])> {
        return repository.getMovieHome(input).flatMap({ response -> Observable<(pageNumber : Int, data: [MovieCollectionViewCellModel])> in
            let films = response.map({d in
                d.data.map{v in
                    v.map({
                        MovieCollectionViewCellModel(url: $0.url, name: $0.name, poster: $0.poster, tag: $0.picTag?.rawValue ?? "")
                    })
                } ?? []
            }).first ?? []
            return Observable.just((response.first?.nextPage ?? -1,films))
        })
    }
    
    func dailymotionM3u8(_ url : String) ->  Observable<[Any]> {
        return repository.dailymotionM3u8(url)
    }
//    func fileOneData(_ input: FileOneRequest) -> Observable<FileOneResponse?> {
//        return repository.fileOneData(input)
//    }
//    func fembedData(_ id: String) -> Observable<[FembedResponse]> {
//        return repository.fembedData(id)
//    }
//    func hhtqEpisode(_ input : HHTQEpisodeRequest) -> Observable<HHTQEpisodeResponse?>  {
//        return repository.hhtqEpisode(input)
//    }
    func movieDetail(_ input : MovieDetailRequest) -> Observable<([EpisodeModel], String)> {
        return repository.movieDetail(input).map({ res in
            let ep : [EpisodeModel] = {
                return res?.episodes?.compactMap({ d -> EpisodeModel? in
                    return EpisodeModel(dataPostID: d.dataPostID, dataServer: d.dataServer, dataEpisodeSlug: d.dataEpisodeSlug, isNew: d.isNew, dataEmbed: d.dataEmbed, episode: d.episode)
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
    func getEpisodeDetail(_ input : EpisodeDetailRequest) -> Observable<EpisodeDetailResponse?> {
        return repository.getEpisodeDetail(input)
    }
}
