//
//  AppAVPlayer.swift
//  Player
//
//  Created by TrucPham on 15/10/2021.
//

import Foundation
import UIKit
import AVKit


class AppAVPlayer : VideoPlayerType {
    
    weak var delegate : VideoPlayerDelegate?
    private var timeObserver: AnyObject?
    private var preferredRate: Float = 1.0
    var shouldLoop: Bool = false
    private var timeStartRecording : Float = 0
    func setVideo(url : String) {
        guard let _url = URL(string: url) else {
            let userInfo = [NSLocalizedDescriptionKey: "url not found."]
            let videoError = NSError(domain: "videoplayer", code: 99, userInfo: userInfo)
            delegate?.error(videoError)
            return
        }
        setVideo(url: _url)
    }
    func setVideo(url : URL) {
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: ["duration", "tracks"])
        
        deinitObservers()
        player.replaceCurrentItem(with: playerItem)
        player.currentItem?.addObserver(self, forKeyPath: "status", options: [], context: nil)
    }
    func playVideo() {
        guard let playerItem = player.currentItem else { return }
        player.rate = preferredRate
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidFinishPlaying(_:)) , name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    func stopVideo() {
        player.rate = 0.0
    }
    
    func pauseVideo(){
        player.rate = 0.0
    }
    
    func seek(to second: Double) {
        guard let currentItem = player.currentItem else { return }
        let time = CMTime(seconds: second, preferredTimescale: currentItem.asset.duration.timescale)
        player.seek(to: time, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: { [weak self] (finished) in
            guard let strongSelf = self else { return }
            if finished == false {
                strongSelf.delegate?.seekStarted()
            } else {
                strongSelf.delegate?.seekEnded()
            }
        })
    }
    func setRate(_ rate : Float) {
        self.preferredRate = rate
        player.rate = rate
    }
    func startRecordVideo() {
        timeStartRecording = Float(self.currentTime)
    }
    func stopRecordVideo(_ fileName : String) {
        guard let asset = self.player.currentItem?.asset else { return }
        self.cropVideo(asset,fileName: fileName, statTime: self.timeStartRecording, endTime: Float(self.currentTime))
        self.timeStartRecording = 0
    }
    
    var videoLength: Double {
        if let duration = player.currentItem?.asset.duration {
            return duration.seconds
        }
        return 0.0
    }
    
    var currentTime: Double {
        if let time = player.currentItem?.currentTime() {
            return time.seconds
        }
        return 0.0
    }
    
    var videoSize: CGSize {
        return player.currentItem?.asset.videoSize ?? .init(width: 16, height: 9)
    }
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI(){
        self.layer.addSublayer(videoPlayerLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.videoPlayerLayer.frame.size = self.bounds.size
        CATransaction.commit()
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
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let asset = object as? AVPlayerItem, let keyPath = keyPath else { return }
        
        if asset == player.currentItem && keyPath == "status" {
            if asset.status == .readyToPlay {
                addTimeObserver()
                delegate?.readyToPlayVideo(videoLength, currentTime: 0)
            } else if asset.status == .failed {
                let userInfo = [NSLocalizedDescriptionKey: "Error loading video."]
                let videoError = NSError(domain: "videoplayer", code: 99, userInfo: userInfo)
                delegate?.error(videoError)
                
            }
        }
    }
    private func addTimeObserver() {
        if let observer = timeObserver {
            player.removeTimeObserver(observer)
        }
        
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.01, preferredTimescale: Int32(NSEC_PER_SEC)), queue: nil, using: { [weak self] (time) in
            guard let strongSelf = self else { return }
            let currentTime = time.seconds
            strongSelf.delegate?.playing(currentTime)
            
        }) as AnyObject?
    }
    
    @objc func itemDidFinishPlaying(_ notification: Notification) {
        let currentItem = player.currentItem
        let notificationObject = notification.object as? AVPlayerItem
        self.delegate?.didFinishPlaying(currentItem == notificationObject && shouldLoop == true)
        if timeStartRecording > 0 { stopRecordVideo(UUID().uuidString) }
    }
    
    private func cropVideo(_ asset: AVAsset, fileName : String, statTime:Float, endTime:Float)
    {
        let manager = FileManager.default

        guard let documentDirectory = try? manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {return}
        let mediaType = "mp4"
        let length = Float(asset.duration.value) / Float(asset.duration.timescale)
        print("video length: \(length) seconds")

        let start = statTime
        let end = endTime

        var outputURL = documentDirectory.appendingPathComponent("videos")
        do {
            try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            outputURL = outputURL.appendingPathComponent("\(fileName).\(mediaType)")
        }catch let error {
            print(error)
        }

        //Remove existing file
        _ = try? manager.removeItem(at: outputURL)


        guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4

        let startTime = CMTime(seconds: Double(start ), preferredTimescale: 1000)
        let endTime = CMTime(seconds: Double(end ), preferredTimescale: 1000)
        let timeRange = CMTimeRange(start: startTime, end: endTime)

        exportSession.timeRange = timeRange
        exportSession.exportAsynchronously{
            switch exportSession.status {
            case .completed:
                self.delegate?.didFinishRecordVideo(url: outputURL, error: nil)
                print("exported at \(outputURL)")
            case .failed:
                self.delegate?.didFinishRecordVideo(url: nil, error: exportSession.error)
                print("failed \(exportSession.error)")
            case .cancelled:
                self.delegate?.didFinishRecordVideo(url: nil, error: exportSession.error)
                print("cancelled \(exportSession.error)")
            default: break
            }
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        deinitObservers()
    }
}

extension AVAsset {
    var videoSize : CGSize {
        guard let track = self.tracks(withMediaType: .video).first else { return .zero }
        let size = track.naturalSize.applying(track.preferredTransform)
        return size
    }
}
