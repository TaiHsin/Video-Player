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
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var volumeButton: UIButton!
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var timeSlider: UISlider!
    
    var player = AVPlayer()
    var playerLayer =  AVPlayerLayer()
    
//    override var prefersStatusBarHidden: Bool {
//        return UIApplication.shared.statusBarOrientation.isLandscape
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Resize when rotate
        playerLayer.videoGravity = .resize
        
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidRotate), name: .UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc func videoDidRotate() {
//        self.setNeedsStatusBarAppearanceUpdate()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Rotate back to portrait before leave view
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Define videoView is the playerLayer's frame
        playerLayer.frame = videoView.bounds
    }
    
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            guard let currentItem = self?.player.currentItem else { return }
            self?.timeSlider.maximumValue = Float(currentItem.duration.seconds)
            self?.timeSlider.minimumValue = 0
            self?.timeSlider.value = Float(currentItem.currentTime().seconds)
            self?.currentTimeLabel.text = self?.getTimeString(from: currentItem.currentTime())
        })
    }
    
    @IBAction func searchAndPlay(_ sender: Any) {
        

        guard let url = urlTextField.text else { return }
        print(url)
        guard let videoUrl = URL(string: url) else { return }
        
        player = AVPlayer(url: videoUrl)
        playerLayer = AVPlayerLayer(player: player)
        videoView.layer.addSublayer(playerLayer)
        addTimeObserver()
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)

        playButton.setImage(#imageLiteral(resourceName: "btn_stop"), for: .normal)
        
        player.play()
        
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
    }
    
    @IBAction func playForward(_ sender: Any) {
        
        // Get total duration of video
        guard let duration = player.currentItem?.duration else { return } // currentItem?
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime + 10.0
        
        if newTime < (CMTimeGetSeconds(duration) - 10.0) {
            let time: CMTime = CMTimeMake(Int64(newTime * 1000), 1000) // why devide by 1000?
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
    
    @IBAction func setFullScreen(_ sender: Any) {
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {

            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            fullScreenButton.setImage(#imageLiteral(resourceName: "btn_fullScreen_exit"), for: .normal)
        } else {
            
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            fullScreenButton.setImage(#imageLiteral(resourceName: "btn_fullScreen"), for: .normal)
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        player.seek(to: CMTimeMake(Int64(sender.value * 1000), 1000))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            self.durationLabel.text = getTimeString(from: player.currentItem!.duration)
        }
    }
    
    func getTimeString(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds / 3600)
        let minutes = Int(totalSeconds / 60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60)) //??
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours, minutes, seconds])
        } else {
            return String(format: "%02i:%02i", arguments: [minutes, seconds])
        }
    }
    
    @IBAction func setVolume(_ sender: Any) {
    }
    
}

// 1. landscape to hide navi bar
// 2. landscape to show control bar
// 3. determine url is valid or not to show "目前沒有可播放的影片"
// 4. Solve duplicate player playing issue when search url more than one time

// What is timescale
// CMTime and seconds convetion
