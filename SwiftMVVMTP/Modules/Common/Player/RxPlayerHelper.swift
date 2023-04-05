////
////  PlayerHelper.swift
////  SwiftMVVMTP
////
////  Created by Truc Pham on 25/09/2021.
////
//
import Foundation
import AVKit
import RxSwift
//struct EpisodeModel {
//    let dataPostID, dataServer, dataEpisodeSlug: String?
//    let isNew: Bool
//    let dataEmbed: String
//    let episode: String
//    let url : String
//}
//enum VideoType {
//    case dailymotion(url: String)
//    case m3u8(url : String)
//    case normal(url : String)
//}
//struct Fileone {
//    let id : String
//    let url : URL
//}
//struct Fembed {
//    let id : String
//    let resolutions : [VideoResolution]
//}
//
//struct Dailymotion {
//    let url : String
//    let resolutions : [VideoResolution]
//}
//struct NormalVideo {
//    let url : URL
//}
//struct VideoResolution {
//    let id : String
//    let resolution : String
//    let url : URL
//    let bandWidth : Double?
//}
//struct UnitRequest : Codable {
//
//}
//struct FileOneResponse : Codable {
//    let url : String?
//}
//struct FileOneRequest : Codable {
//    let url : String
//}
//// MARK: - FembedResponse
//struct FembedResponse: Codable {
//    let file: String?
//    let label, type: String?
//}
//
//enum VideoPlayer {
//    case dailymotion(Dailymotion)
//    case fileone(Fileone)
//    case fembed(Fembed)
//    case normal(NormalVideo)
//}
//class RxPlayerHelper : NSObject {
//    static var shared : RxPlayerHelper = .init()
//
//    @Dependency.Inject
//    var movieService : MovieService
//
//    var videos : [String : VideoPlayer] = [:]
//    private weak var viewController: UIViewController!
//    private lazy var player: AVPlayer = {
//        let player = AVPlayer(playerItem: nil)
//        return player
//    }()
//    private lazy var playerController: LandscapeAVPlayerController = {
//        let playerController = LandscapeAVPlayerController()
//        playerController.player = player
//        playerController.entersFullScreenWhenPlaybackBegins = true
//        playerController.allowsPictureInPicturePlayback = true
//        playerController.delegate = self
//        playerController.showsPlaybackControls = true
//        if #available(iOS 14.2, *) {
//            playerController.canStartPictureInPictureAutomaticallyFromInline = true
//        } else {
//            // Fallback on earlier versions
//        }
//
//        playerController.videoGravity = .resizeAspect
//        return playerController
//    }()
//    private override init() {}
//    func openPlayer(_ controller : UIViewController, videoType : VideoType, openVideoController : Bool = true) -> Observable<VideoPlayer?> {
//        viewController = controller
//        switch videoType {
//        case let .dailymotion(url):
//            return self.getM3u8(url: url).flatMap({ video -> Observable<VideoPlayer?> in
//                if let lastResolution = video.last {
//                    if openVideoController {
//                        return self.playerVideo(url: lastResolution.url).map({
//                            self.videos[url]
//                        })
//                    }
//                    else {
//                        return Observable.just(self.videos[url])
//                    }
//                }
//                return Observable.just(nil)
//            })
//        case let .normal(url), let .m3u8(url):
//            guard let url = URL(string: url) else {
//                return Observable.just(nil)
//            }
//            if openVideoController {
//                return self.playerVideo(url: url).map({
//                    VideoPlayer.normal(.init(url: url))
//                })
//            }
//            else {
//                return Observable.just( VideoPlayer.normal(.init(url: url)))
//            }
//
//
//        }
//    }
//
////    func openPlayer(_ controller : UIViewController, data : EpisodeModel, openVideoController : Bool = true) -> Observable<VideoPlayer?> {
//////        let episode : Observable<EpisodeModel?> = {
//////            Observable.deferred({() ->  Observable<EpisodeModel?> in
//////                if let url = data.link {
//////                    return self.movieService.getEpisodeDetail(.init(url: url)).map({res -> EpisodeModel? in
//////                        guard let id = res?.id, let url = res?.url, let type = res?.type else { return nil}
//////                        return  EpisodeModel(episode: data.episode, id: id, link: url, isNew: data.isNew, type: type)
//////                    })
//////                }
//////                return Observable.just(data)
//////            })
//////        }()
////        return self.movieService.getEpisodeDetail(.init(episodeSlug: data.dataEpisodeSlug, serverID: data.dataServer, subsvID: "1", postID: data.dataPostID, nonce: "", customVar: "")).flatMap({[weak self] _res -> Observable<VideoPlayer?>  in
////            if let _self = self, let data = _res?.data {
////                if let _url = data.url {
////                    switch data.type {
////                    case .normal, .m3u8:
////                        return _self.openPlayer(controller, videoType: .normal(url: _url), openVideoController: openVideoController)
////                    case .dailymotion:
////                        return _self.openPlayer(controller, videoType: .dailymotion(url: _url), openVideoController: openVideoController)
////                    default: break
////
////                    }
////                }
////
////            }
////            return Observable.just(nil)
////        })
////    }
//
////    func getFembed(id : String) -> Observable<[VideoResolution]>{
////        guard let _v = self.videos[id], case let VideoPlayer.fembed(video) = _v else {
////            return self.movieService.fembedData(id).map({res in
////                return res.compactMap({ v -> VideoResolution? in
////                    if let _url = v.file, let url = URL(string: _url) {
////                        return VideoResolution(id: UUID().uuidString, resolution: v.label ?? "unkown", url: url, bandWidth: 0)
////                    }
////                    return nil
////                })
////            }).do(onNext: {
////                self.videos[id] = VideoPlayer.fembed(.init(id: id, resolutions: $0))
////            })
////        }
////        return Observable.just(video.resolutions)
////    }
//
//
////    func getFileOne(id: String, url : String) -> Observable<URL?> {
////        guard let _v = self.videos[id], case let VideoPlayer.fileone(video) = _v else {
////            return self.movieService.fileOneData(FileOneRequest(url: url)).map({res in
////                if let urlString = res?.url, let url = URL(string: urlString) {
////                    return url
////                }
////                return nil
////            }).do(onNext: {
////                guard let url = $0 else {return}
////                self.videos[id] = VideoPlayer.fileone(.init(id: id, url: url))
////            })
////        }
////        return Observable.just(video.url)
////    }
//
//
//
//    // MARK: M3u8
//
//
////    func getM3u8(url : String) -> Observable<[VideoResolution]>{
////        guard let _v = self.videos[url], case let VideoPlayer.dailymotion(video) = _v else {
////            return self.movieService.dailymotionM3u8(url).map({ response in
////                return response.compactMap({ v -> VideoResolution? in
////                    if let res = v as? [String : Any], let url = URL(string: res["LINK"] as! String), let resolution = res["RESOLUTION"] as? Substring {
////                        return VideoResolution(id: UUID().uuidString, resolution: String(resolution), url: url, bandWidth: Double((res["BANDWIDTH"] as? Substring) ?? "0"))
////                    }
////                    return nil
////                })
////            }).do(onNext: {
////                self.videos[url] = VideoPlayer.dailymotion(.init(url: url, resolutions: $0))
////            })
////        }
////        return Observable.just(video.resolutions)
////
////    }
//
//    func getUrl(_ type: VideoPlayer, resolationId: String? = nil) ->  [URL] {
//        switch type {
//        case .dailymotion(let d):
//            if let resolationId = resolationId, !resolationId.isEmpty {
//                return d.resolutions.compactMap({
//                    if resolationId == $0.id {
//                        return  $0.url
//                    }
//                    return nil
//                })
//            }
//            return d.resolutions.compactMap({
//                $0.url
//            })
//        case .fembed(let d):
//            if let resolationId = resolationId, !resolationId.isEmpty {
//                return d.resolutions.compactMap({
//                    if resolationId == $0.id {
//                        return  $0.url
//                    }
//                    return nil
//                })
//            }
//            return d.resolutions.map({
//                $0.url
//            })
//        case .fileone(let d):
//            return [d.url]
//        case .normal(let d):
//           return [d.url]
//        }
//    }
//
//
//    fileprivate func playerVideo(url : URL) -> Observable<Void> {
//        Observable.create({emit in
//            self.player.replaceCurrentItem(with: AVPlayerItem(url: url))
//            self.viewController.present(self.playerController, animated: true, completion: {
//                self.player.play()
//            })
//            emit.onCompleted()
//            return Disposables.create()
//        })
//
//    }
//    static func enableBackgroundMode() {
//        let audioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(.playback, mode: .moviePlayback)
//        }
//        catch {
//            print("Setting category to AVAudioSessionCategoryPlayback failed.")
//        }
//    }
//}
//extension RxPlayerHelper : AVPlayerViewControllerDelegate {
//    func playerViewController(_ playerViewController: AVPlayerViewController,
//                              restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
//        if playerViewController === viewController.presentedViewController {
//            return
//        }
//        viewController.present(playerViewController, animated: true) {
//            playerViewController.player?.play()
//            completionHandler(false)
//        }
//    }
//
//
//    func playerViewController(_ playerViewController: AVPlayerViewController, failedToStartPictureInPictureWithError error: Error) {
//        print("failedToStartPictureInPictureWithError")
//    }
//
//    func playerViewControllerDidStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
//        print("playerViewControllerDidStartPictureInPicture")
//    }
//
//    func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
//        print("playerViewControllerDidStopPictureInPicture")
//    }
//
//
//}
class LandscapeAVPlayerController: AVPlayerViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

