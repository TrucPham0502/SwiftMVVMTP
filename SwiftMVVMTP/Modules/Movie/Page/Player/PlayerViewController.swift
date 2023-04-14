//
//  PlayerViewController.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 05/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import AVKit
import WebKit
struct PlayerModel {
    struct Media {
        let url : String
        let type: MediaType
        enum MediaType : String {
            case m3u8
            case `default`
        }
    }
    struct Sublink {
        let subsv : String
        let name : String
    }
    let media : Media
    let sublinks : [Sublink]
}
class PlayerViewController : BaseViewController<PlayerViewModel>{
    override func buildViewModel() -> PlayerViewModel {
        return PlayerViewModel()
    }
    var urlString: String = ""
    private lazy var player: AVPlayer = {
        let player = AVPlayer(playerItem: nil)
        return player
    }()
    private lazy var playerController: LandscapeAVPlayerController = {
        let playerController = LandscapeAVPlayerController()
        playerController.player = player
        playerController.entersFullScreenWhenPlaybackBegins = true
        playerController.allowsPictureInPicturePlayback = true
        playerController.delegate = self
        playerController.showsPlaybackControls = true
        if #available(iOS 14.2, *) {
            playerController.canStartPictureInPictureAutomaticallyFromInline = true
        } else {
            // Fallback on earlier versions
        }
        playerController.parrentController = self
        playerController.videoGravity = .resizeAspect
        return playerController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    
    func play(url: URL){
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        self.player.replaceCurrentItem(with: playerItem)
        self.present(self.playerController, animated: true) {
            self.player.play()
        }
    }
    
    func playWithWebView(url : URL) {
        if let app = UIApplication.shared.delegate as? AppDelegate {
            self.dismiss(animated: false, completion: nil)
            app.playViewWithWebView(url: url)
        }
    }
    
    override func showToast(message: String, complete : ((UIAlertAction) -> ())? = nil) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {_ in
            self.dismiss(animated: false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func performBinding() {
        super.performBinding()
        let output = viewModel.transform(
            input: .init(
                viewWillAppear: self.rx.viewWillAppear.take(1).map{[weak self] _ in
                    return self?.urlString ?? ""
                }.asDriverOnErrorJustComplete()
            ))
        output.item.drive(onNext: {[weak self] media in
            guard let self = self else { return }
            switch media {
            case let .item(value):
                guard !value.media.url.isEmpty, let url = URL(string: value.media.url) else { return }
//                if value.media.type == .m3u8 {
//                    self.playWithWebView(url: url)
//                }
//                else {
//                    self.play(url: url)
//                }
                self.playWithWebView(url: url)
                
            default: break
            }
            
        }).disposed(by: self.disposeBag)
        
    }
   
    
}
extension PlayerViewController : AVPlayerViewControllerDelegate {
    func playerViewController(_ playerViewController: AVPlayerViewController,
                              restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        if playerViewController === self.presentedViewController {
            return
        }
        self.present(playerViewController, animated: true) {
            playerViewController.player?.play()
            completionHandler(false)
        }
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, willEndFullScreenPresentationWithAnimationCoordinator coordinator: UIViewControllerTransitionCoordinator) {
    }
    
    
    func playerViewController(_ playerViewController: AVPlayerViewController, failedToStartPictureInPictureWithError error: Error) {
        print("failedToStartPictureInPictureWithError")
    }
    
    func playerViewControllerDidStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
        print("playerViewControllerDidStartPictureInPicture")
    }
    
    func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        print("playerViewControllerDidStopPictureInPicture")
    }
    
}
class LandscapeAVPlayerController: AVPlayerViewController {
    weak var parrentController : UIViewController?
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        parrentController?.dismiss(animated: false, completion: nil)
    }
}
