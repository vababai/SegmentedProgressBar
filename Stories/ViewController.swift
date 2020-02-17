//
//  ViewController.swift
//  Stories
//
//  Created by Евгений Салов on 06.02.2020.
//  Copyright © 2020 Евгений Салов. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, SegmentedProgressBarDelegate, VideoViewDelegate {
    
    @IBOutlet var progressBarView: SegmentedProgressBar!
    @IBOutlet var videoView: VideoView!
    var isProgressBarFirstStart = true
    
    let videoURLs = [
        Bundle.main.url(forResource: "video1", withExtension: "mp4"),
        Bundle.main.url(forResource: "video2", withExtension: "mp4"),
        Bundle.main.url(forResource: "video3", withExtension: "mp4")
        //URL(string: "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726")
    ]
    
    func segmentedProgressBarChangedIndex(index: Int) {
        guard videoURLs.count > index, let url = videoURLs[index] else { return }
        videoView.stop()
        progressBarView.isPaused = true
        DispatchQueue.main.async {
            if self.isProgressBarFirstStart {
                self.progressBarView.startAnimation()
                self.isProgressBarFirstStart = false
            }
            self.videoView.configure(videoUrl: url)
            
            self.progressBarView.duration = CMTimeGetSeconds(self.videoView.duration ?? CMTime.init())
            //print(progressBarView.duration)
            self.videoView.play()
            self.videoView.isLoop = self.videoURLs.index(after: index) == self.videoURLs.count
        }
        
    }
    
    func segmentedProgressBarFinished() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBarView.delegate = self
        videoView.delegate = self
        
        progressBarView.numberOfSegments = videoURLs.count
        segmentedProgressBarChangedIndex(index: 0)
        //progressBarView.startAnimation()
        setupGestureRecognizer()
    }
    
    func setupGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        videoView.addGestureRecognizer(tap)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        videoView.addGestureRecognizer(longPress)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        let location = sender?.location(in: videoView)
        if let x = location?.x, x <= videoView.bounds.width / 2 {
            progressBarView.rewind()
        } else {
            progressBarView.skip()
            
        }
    }
    
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        
    }
    
    func videoStarted() {
        progressBarView.isPaused = false
    }
    
}

