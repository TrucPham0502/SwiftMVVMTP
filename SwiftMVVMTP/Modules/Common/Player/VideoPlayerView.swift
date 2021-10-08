//
//  VideoPlayerView.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 07/10/2021.
//

import Foundation
import AVKit
import UIKit
public enum PlayerStatus {
    case new
    case readyToPlay
    case playing
    case paused
    case stopped
    case error
}
class VideoPlayerView : UIView {
    private lazy var videoPlayerLayer : AVPlayerLayer = {
        let v = AVPlayerLayer()
        v.videoGravity = AVLayerVideoGravity.resizeAspectFill
        v.player = player
        v.contentsScale = UIScreen.main.scale
        return v
    }()
    private lazy var player : AVPlayer = {
        let v = AVPlayer()
        return v
    }()
    private lazy var videoControl : VideoPlayerControls = {
        let v = VideoPlayerControls()
        v.backgroundColor = .black.withAlphaComponent(0.5)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    fileprivate(set) var status: PlayerStatus = .new
    fileprivate(set) var progress: Double = 0.0
    var shouldLoop: Bool = false
    var timeObserver: AnyObject?
    var preferredRate: Float = 1.0
    var videoURL: URL? = nil {
        didSet {
            guard let url = videoURL else {
                status = .error
                let userInfo = [NSLocalizedDescriptionKey: "Video URL is invalid."]
                let videoError = NSError(domain: "com.andreisergiupitis.aspvideoplayer", code: 99, userInfo: userInfo)
                print(videoError.localizedDescription)
                return
            }

            let asset = AVAsset(url: url)
            setVideoAsset(asset: asset)
        }
    }
    var videoAsset: AVAsset? = nil {
        didSet {
            guard let asset = videoAsset else {
                status = .error

                let userInfo = [NSLocalizedDescriptionKey: "Video asset is invalid."]
                let videoError = NSError(domain: "com.andreisergiupitis.aspvideoplayer", code: 99, userInfo: userInfo)
                print(videoError.localizedDescription)
                return
            }

            setVideoAsset(asset: asset)
        }
    }
    var currentTime: Double {
        if let time = player.currentItem?.currentTime() {
            return time.seconds
        }

        return 0.0
    }
    var videoLength: Double {
        if let duration = player.currentItem?.asset.duration {
            return duration.seconds
        }

        return 0.0
    }
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareUI()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        videoPlayerLayer.frame = bounds
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let asset = object as? AVPlayerItem, let keyPath = keyPath else { return }

        if asset == player.currentItem && keyPath == "status" {
            if asset.status == .readyToPlay {
                if status == .new {
                    status = .readyToPlay
                }
                addTimeObserver()
                videoControl.readyToPlayVideo(Int(videoLength), currentTime: 0)
            } else if asset.status == .failed {
                status = .error

                let userInfo = [NSLocalizedDescriptionKey: "Error loading video."]
                let videoError = NSError(domain: "com.andreisergiupitis.aspvideoplayer", code: 99, userInfo: userInfo)
                print(videoError.localizedDescription)

            }
        }
    }
    private func prepareUI(){
        layer.addSublayer(videoPlayerLayer)
        self.addSubview(videoControl)
        NSLayoutConstraint.activate([
            self.videoControl.topAnchor.constraint(equalTo: self.topAnchor),
            self.videoControl.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.videoControl.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.videoControl.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc func playVideo() {
        guard let playerItem = player.currentItem else { return }

        if progress >= 1.0 {
            seekToZero()
        }

        status = .playing
        player.rate = preferredRate
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidFinishPlaying(_:)) , name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    @objc internal func itemDidFinishPlaying(_ notification: Notification) {
        let currentItem = player.currentItem
        let notificationObject = notification.object as? AVPlayerItem

        if currentItem == notificationObject && shouldLoop == true {
            status = .playing
            seekToZero()
            player.rate = preferredRate
        } else {
            stopVideo()
        }
    }
    func stopVideo() {
        player.rate = 0.0
        seekToZero()
        status = .stopped
    }
    private func seekToZero() {
        progress = 0.0
        let time = CMTime(seconds: 0.0, preferredTimescale: 1)
        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    func pauseVideo() {
       player.rate = 0.0
       status = .paused
   }
    func seek(_ percentage: Double) {
        progress = min(1.0, max(0.0, percentage))
        guard let currentItem = player.currentItem else { return }

        if progress == 0.0 {
            seekToZero()
        } else {
            let time = CMTime(seconds: progress * currentItem.asset.duration.seconds, preferredTimescale: currentItem.asset.duration.timescale)
            player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: { [weak self] (finished) in
                guard let strongSelf = self else { return }

                if finished == false {
                } else {
                }
            })
        }
    }
    private func setVideoAsset(asset: AVAsset) {
        let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: ["duration", "tracks"])

        deinitObservers()
        player.replaceCurrentItem(with: playerItem)
        player.currentItem?.addObserver(self, forKeyPath: "status", options: [], context: nil)
        videoControl.newVideo()
        status = .new
    }
    private func addTimeObserver() {
        if let observer = timeObserver {
            player.removeTimeObserver(observer)
        }

        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.01, preferredTimescale: Int32(NSEC_PER_SEC)), queue: nil, using: { [weak self] (time) in
            guard let strongSelf = self, strongSelf.status == .playing else { return }

            let currentTime = time.seconds
            strongSelf.videoControl.seek(to: Int(currentTime))

        }) as AnyObject?
    }
    private func deinitObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        if let video = player.currentItem, video.observationInfo != nil {
            video.removeObserver(self, forKeyPath: "status")
        }
        
        if let observer = timeObserver {
            player.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
}
