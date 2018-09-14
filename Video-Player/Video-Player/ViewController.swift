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
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        guard let url = URL(string: "https://s3-ap-northeast-1.amazonaws.com/mid-exam/Video/taeyeon.mp4") else { return }
//        player = AVPlayer(url: url)
//
//        playerLayer = AVPlayerLayer(player: player)
//
//        // Resize when rotate
//        playerLayer.videoGravity = .resize
//
//        videoView.layer.addSublayer(playerLayer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchButton.layer.cornerRadius = 5
        searchButton.layer.borderColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1).cgColor
        searchButton.layer.borderWidth = 1
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        player.play()
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Define videoView is the playerLayer's frame
        
    }
    
    @IBAction func searchAndPlay(_ sender: Any) {
        
        guard let url = urlTextField.text else { return }
        print(url)
        guard let videoUrl = URL(string: url) else { return }
        player = AVPlayer(url: videoUrl)
        
        playerLayer = AVPlayerLayer(player: player)
        
        // Resize when rotate
        playerLayer.videoGravity = .resize
        
        videoView.layer.addSublayer(playerLayer)
        playerLayer.frame = videoView.bounds
        player.play()

    }
    
    @IBAction func playVideo(_ sender: Any) {
        player.pause()
    }
    
    @IBAction func playForward(_ sender: Any) {
    }
    @IBAction func playRewind(_ sender: Any) {
    }
    
//    @IBAction func setFullScreen(_ sender: Any) {
//    }
    
    @IBAction func setVolume(_ sender: Any) {
    }
    
}

