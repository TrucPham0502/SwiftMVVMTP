//
//  PlayerViewController.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 05/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import AVKit
struct PlayerModel {
    struct Media {
        let url : String
        let type: String
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
        
        playerController.videoGravity = .resizeAspect
        return playerController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
    
    
    func play(url: URL){
        self.player.replaceCurrentItem(with: AVPlayerItem(url: url))
        self.present(self.playerController, animated: true, completion: {
            self.player.play()
        })
    }
    
    override func showToast(message: String) {
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
                }
            ))
        output.item.drive(onNext: {[weak self] media in
            guard let self = self else { return }
            guard !media.media.url.isEmpty, let url = URL(string: media.media.url) else { return }
            self.play(url: url)
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
        self.dismiss(animated: false, completion: nil)
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
