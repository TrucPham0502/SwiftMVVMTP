//
//  SplashScreenViewController.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 15/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
class SplashScreenViewController: UIViewController {
    var playerSize : CGSize {
        return CGSize(width: self.view.bounds.width - 200, height: (self.view.bounds.width - 100) * 16 / 9)
    }
    var player: AVPlayer!
    var playerLayer : AVPlayerLayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setupVideoBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
    private func setupVideoBackground() {
        guard let path = Bundle.main.path(forResource: "backgroundVideo", ofType: ".mov") else {
            debugPrint("backgroundVideo.mov not found")
            return
        }

        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = .init(origin: .init(x: (self.view.bounds.width - playerSize.width)/2, y: (self.view.bounds.height - playerSize.height)/2), size: playerSize)
        playerLayer.videoGravity = .resizeAspect
        view.layer.insertSublayer(playerLayer, at: 0)

        NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    @objc private func videoDidEnd(notification: NSNotification) {
        UIView.animate(withDuration: 2, delay: 1, options: [.curveEaseInOut]) {
            self.playerLayer.opacity = 0
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let app = UIApplication.shared.delegate as? AppDelegate {
                    app.window?.rootViewController = UINavigationController(rootViewController: MovieHomeViewController())
                }
            }
        }

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
