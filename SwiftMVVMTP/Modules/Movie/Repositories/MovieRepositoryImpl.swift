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
        return remoteSource.getPlayInfo(input).valid()
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
    
    
    
    
    
    
//    func dailymotionM3u8(_ url : String) ->  Observable<[Any]> {
//        return remoteSource.dailymotionM3u8(url).valid().flatMap({responseString -> Observable<[Any]> in
//                var resultArr = [Any]()
//                let tmpStr = "#EXT-X-STREAM-INF:"
//                let ArrayCop = responseString?.components(separatedBy: tmpStr)
//                var croppedArr =  [Any]()
//                croppedArr =  Array((ArrayCop?.dropFirst())!)
//                let enterChar = "\n"
//                let spaceChar = ","
//                for i in 0..<(croppedArr.count) {
//                    var parsedDic = [String:Any]()
//                    let tmpArr1 =  ((croppedArr[i] as! String).trimmingCharacters(in: .whitespacesAndNewlines) ).components(separatedBy: enterChar)
//                    parsedDic["LINK"] = tmpArr1.last!
//                    let finalStr = tmpArr1[0]
//                    let arrayofCom = finalStr.components(separatedBy: spaceChar)
//                    for ind in 0..<arrayofCom.count {
//                        if arrayofCom[ind].contains("BANDWIDTH=") {
//                            parsedDic["BANDWIDTH"] = arrayofCom[ind].dropFirst(10)
//                        }
//                        if arrayofCom[ind].contains("RESOLUTION=") {
//                            parsedDic["RESOLUTION"] = arrayofCom[ind].dropFirst(11)
//                        }
//                    }
//                    resultArr.append(parsedDic)
//                }
//                return Observable.just(resultArr)
//            })
//    }
    
//    func fileOneData(_ input: FileOneRequest) -> Observable<FileOneResponse?> {
//        return remoteSource.fileOneData(input).validResponse()
//    }
//    func fembedData(_ id: String) -> Observable<[FembedResponse]> {
//        return remoteSource.fembedData(id).validResponse()
//    }
//    func hhtqEpisode(_ input : HHTQEpisodeRequest) -> Observable<HHTQEpisodeResponse?> {
//        return remoteSource.hhtqEpisode(input).validResponse()
//    }
   
    
//    func getEpisodeDetail(_ input : EpisodeDetailRequest) -> Observable<EpisodeDetailResponse?> {
//        return remoteSource.getEpisodeDetail(input).valid()
//    }
}
