//
//  ViewController.swift
//  Video-Player
//
//  Created by TaiHsinLee on 2018/9/14.
//  Copyright © 2018年 TaiHsinLee. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var volumeButton: UIButton!
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    
    var player = AVPlayer()
    var playerLayer =  AVPlayerLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Resize when rotate
        playerLayer.videoGravity = .resize
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchButton.layer.cornerRadius = 5
        searchButton.layer.borderColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1).cgColor
        searchButton.layer.borderWidth = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Define videoView is the playerLayer's frame
        playerLayer.frame = videoView.bounds
        
    }
    
    @IBAction func searchAndPlay(_ sender: Any) {
        guard let url = urlTextField.text else { return }
        print(url)
        guard let videoUrl = URL(string: url) else { return }
        
        player = AVPlayer(url: videoUrl)
        playerLayer = AVPlayerLayer(player: player)
        videoView.layer.addSublayer(playerLayer)
        
        player.play()
        
        playButton.setImage(#imageLiteral(resourceName: "btn_stop"), for: .normal)
        
        urlTextField.text = ""

    }
    
    @IBAction func playPressed(_ sender: UIButton) {
        
        if player.rate == 0 {
            player.play()
            sender.setImage(#imageLiteral(resourceName: "btn_stop"), for: .normal)
        } else {
            player.pause()
            sender.setImage(#imageLiteral(resourceName: "btn_play"), for: .normal)
        }
        
//        if isVideoPlaying {
//            player.pause()
//            sender.setImage(#imageLiteral(resourceName: "btn_play"), for: .normal)
//        } else {
//            player.play()
//            sender.setImage(#imageLiteral(resourceName: "btn_stop"), for: .normal)
//        }
//        isVideoPlaying = !isVideoPlaying
    }
    
    @IBAction func playForward(_ sender: Any) {
        
        // Get total duration of video
        guard let duration = player.currentItem?.duration else { return }
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime + 10.0
        
        if newTime < (CMTimeGetSeconds(duration) - 10.0) {
            let time: CMTime = CMTimeMake(Int64(newTime * 1000), 1000)
            player.seek(to: time)
        }
    }
    @IBAction func playRewind(_ sender: Any) {
        let currenTime = CMTimeGetSeconds(player.currentTime())
        var newTime = currenTime - 10.0
        
        if newTime < 0 {
            newTime = 0
        }
        let time: CMTime = CMTimeMake(Int64(newTime * 1000), 1000)
        player.seek(to: time)
    }
    
//    @IBAction func setFullScreen(_ sender: Any) {
//    }
    
    @IBAction func setVolume(_ sender: Any) {
    }
    
}

// 1. landscape to hide navi bar
// 2. landscape to show control bar
// 3. determine url is valid or not to show "目前沒有可播放的影片"
// 4. Solve duplicate player playing issue when search url more than one time

// What is timescale
// CMTime and seconds convetion
