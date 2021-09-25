//
//  MovieRepositoryImpl.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxSwift
class MovieRepositoryImpl : BaseRepository , MovieRepository {
    @Dependency.Inject
    var remoteSource : MovieRemoteSource
    
    func getMovieHome(_ input: MovieHomeRequest, pageType : PageType) -> Observable<[MovieHomeResponse]> {
        return remoteSource.getMovieHome(input, pageType: pageType).flatMap({ d -> Observable<[MovieHomeResponse]>  in
            return self.unwrap(d).map({
                return $0 ?? []
            })
        })
    }
    
    func dailymotionM3u8(_ id : String) ->  Observable<[Any]> {
        return remoteSource.dailymotionM3u8(id).flatMap({
            return self.unwrap($0).flatMap({responseString -> Observable<[Any]> in
                var resultArr = [Any]()
                let tmpStr = "#EXT-X-STREAM-INF:"
                let ArrayCop = responseString?.components(separatedBy: tmpStr)
                var croppedArr =  [Any]()
                croppedArr =  Array((ArrayCop?.dropFirst())!)
                let enterChar = "\n"
                let spaceChar = ","
                for i in 0..<(croppedArr.count) {
                    var parsedDic = [String:Any]()
                    let tmpArr1 =  ((croppedArr[i] as! String).trimmingCharacters(in: .whitespacesAndNewlines) ).components(separatedBy: enterChar)
                    parsedDic["LINK"] = tmpArr1.last!
                    let finalStr = tmpArr1[0]
                    let arrayofCom = finalStr.components(separatedBy: spaceChar)
                    for ind in 0..<arrayofCom.count {
                        if arrayofCom[ind].contains("BANDWIDTH=") {
                            parsedDic["BANDWIDTH"] = arrayofCom[ind].dropFirst(10)
                        }
                        if arrayofCom[ind].contains("RESOLUTION=") {
                            parsedDic["RESOLUTION"] = arrayofCom[ind].dropFirst(11)
                        }
                    }
                    resultArr.append(parsedDic)
                }
                return Observable.just(resultArr)
            })
            
        })
    }
    
    func fileOneData(_ input: FileOneRequest) -> Observable<FileOneResponse?> {
        return remoteSource.fileOneData(input).flatMap({
            return self.unwrap($0).map({ res in
                return res
            })
        })
    }
    func fembedData(_ id: String) -> Observable<[FembedResponse]> {
        return remoteSource.fembedData(id).flatMap({
            return self.unwrap($0).map({ res in
                return res ?? []
            })
        })
    }
    func hhtqEpisode(_ input : HHTQEpisodeRequest) -> Observable<HHTQEpisodeResponse?> {
        return remoteSource.hhtqEpisode(input).flatMap({
            return self.unwrap($0).map({
                return $0
            })
        })
    }
    func movieDetail(_ input : MovieDetailRequest, pageType : PageType) -> Observable<MovieDetailResponse?> {
        return remoteSource.movieDetail(input, pageType: pageType).flatMap({
            return self.unwrap($0).map({
                return $0
            })
        })
    }
}
