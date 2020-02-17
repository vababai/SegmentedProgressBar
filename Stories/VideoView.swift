//
//  VideoView.swift
//  Stories
//
//  Created by Евгений Салов on 06.02.2020.
//  Copyright © 2020 Евгений Салов. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

protocol VideoViewDelegate {
    func videoStarted()
}

class VideoView: UIView {
    
    lazy var duration: CMTime? = player?.currentItem?.asset.duration
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = false
    var delegate: VideoViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func configure(videoUrl: URL) {
        player = AVPlayer(url: videoUrl)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        if let playerLayer = self.playerLayer {
            layer.addSublayer(playerLayer)
        }
        duration = player?.currentItem?.asset.duration
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        
        if #available(iOS 10.0, *) {
            player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        } else {
            player?.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
        }
        
        player?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    func play() {
        if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            player?.play()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" || keyPath == "timeControlStatus" {
            guard let player = player else { return }
            if #available(iOS 10.0, *), player.timeControlStatus == .playing {
                delegate?.videoStarted()
            } else if keyPath == "status", player.status == .readyToPlay {
                delegate?.videoStarted()
            }
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
    }
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        if isLoop {
            player?.pause()
            player?.seek(to: CMTime.zero)
            player?.play()
        }
    }
}
