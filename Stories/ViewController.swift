//
//  ViewController.swift
//  Stories
//
//  Created by Евгений Салов on 06.02.2020.
//  Copyright © 2020 Евгений Салов. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController, SegmentedProgressBarDelegate {
    
    @IBOutlet var progressBarView: SegmentedProgressBar!
    @IBOutlet var videoView: VideoView!
    
    
    func segmentedProgressBarChangedIndex(index: Int) {
        let url = Bundle.main.url(forResource: "video2", withExtension: "mp4")
                videoView.configure(videoUrl: url!)
                videoView.isLoop = true
                videoView.play()
    }
    
    func segmentedProgressBarFinished() {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = Bundle.main.url(forResource: "video1", withExtension: "mp4")
        videoView.configure(videoUrl: url!)
//        videoView.configure(url: "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726")
        videoView.isLoop = true
        videoView.play()
        
        progressBarView.numberOfSegments = 5
        progressBarView.duration = 5
        progressBarView.startAnimation()
        
        progressBarView.delegate = self
        
    }

    

}

