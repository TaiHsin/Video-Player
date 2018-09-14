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
    @IBOutlet weak var controlBarToBottom: NSLayoutConstraint!
    @IBOutlet weak var slideToControlBar: NSLayoutConstraint!
    
    var player = AVPlayer()
    var playerLayer =  AVPlayerLayer()
    let buttonString = Constants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerLayer.videoGravity = .resize
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
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
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
        
        urlTextField.text = Constants.emptyString
    }
    
    @IBAction func playPressed(_ sender: UIButton) {
        
        if player.rate == 0 {
            player.play()
            
            let image = UIImage(named: Constants.stop)?.withRenderingMode(.alwaysTemplate)
            playButton.setImage(image, for: .normal)
        } else {
            player.pause()
            let image = UIImage(named: Constants.play)?.withRenderingMode(.alwaysTemplate)
            playButton.setImage(image, for: .normal)
        }
    }
    
    @IBAction func playForward(_ sender: Any) {
 
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
    
    @IBAction func setFullScreen(_ sender: Any) {
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
            currentTimeLabel.textColor = UIColor.white
            durationLabel.textColor = UIColor.white
            
            let rewindImage = UIImage(named: Constants.playRewind)?.withRenderingMode(.alwaysTemplate)
            rewindButton.setImage(rewindImage, for: .normal)
            rewindButton.tintColor = UIColor.white
            
            let forwardImage = UIImage(named: Constants.playForward)?.withRenderingMode(.alwaysTemplate)
            forwardButton.setImage(forwardImage, for: .normal)
            forwardButton.tintColor = UIColor.white
            
            let fullScreenImage = UIImage(named: Constants.fullScreenExit)?.withRenderingMode(.alwaysTemplate)
            fullScreenButton.setImage(fullScreenImage, for: .normal)
            fullScreenButton.tintColor = UIColor.white
            
            if player.rate == 0 {
                let image = UIImage(named: Constants.stop)?.withRenderingMode(.alwaysTemplate)
                playButton.setImage(image, for: .normal)
                playButton.tintColor = UIColor.white
            } else {
                let image = UIImage(named: Constants.play)?.withRenderingMode(.alwaysTemplate)
                playButton.setImage(image, for: .normal)
                playButton.tintColor = UIColor.white
            }
            
            if player.volume == 0 {
                let volumeImage = UIImage(named: Constants.volumeUp)?.withRenderingMode(.alwaysTemplate)
                volumeButton.setImage(volumeImage, for: .normal)
                volumeButton.tintColor = UIColor.white
            } else {
                let volumeImage = UIImage(named: Constants.volumeOff)?.withRenderingMode(.alwaysTemplate)
                volumeButton.setImage(volumeImage, for: .normal)
                volumeButton.tintColor = UIColor.white
            }
            
            controlBarToBottom.constant = 10
            slideToControlBar.constant = 10
            
            navigationController?.navigationBar.isHidden = true
            
        } else {
            
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            
            currentTimeLabel.textColor = UIColor.black
            durationLabel.textColor = UIColor.black
            
            let volumeImage = UIImage(named: Constants.volumeUp)?.withRenderingMode(.alwaysTemplate)
            volumeButton.setImage(volumeImage, for: .normal)
            volumeButton.tintColor = UIColor.black
            
            let rewindImage = UIImage(named: Constants.playRewind)?.withRenderingMode(.alwaysTemplate)
            rewindButton.setImage(rewindImage, for: .normal)
            rewindButton.tintColor = UIColor.black
     
            let forwardImage = UIImage(named: Constants.playForward)?.withRenderingMode(.alwaysTemplate)
            forwardButton.setImage(forwardImage, for: .normal)
            forwardButton.tintColor = UIColor.black
            
            let fullScreenImage = UIImage(named: Constants.fullScreen)?.withRenderingMode(.alwaysTemplate)
            fullScreenButton.setImage(fullScreenImage, for: .normal)
            fullScreenButton.tintColor = UIColor.black
            
            if player.rate == 0 {
                let image = UIImage(named: Constants.stop)?.withRenderingMode(.alwaysTemplate)
                playButton.setImage(image, for: .normal)
                playButton.tintColor = UIColor.black
            } else {
                let image = UIImage(named: Constants.play)?.withRenderingMode(.alwaysTemplate)
                playButton.setImage(image, for: .normal)
                playButton.tintColor = UIColor.black
            }
            
            if player.volume == 0 {
                let volumeImage = UIImage(named: Constants.volumeUp)?.withRenderingMode(.alwaysTemplate)
                volumeButton.setImage(volumeImage, for: .normal)
                volumeButton.tintColor = UIColor.black
            } else {
                let volumeImage = UIImage(named: Constants.volumeOff)?.withRenderingMode(.alwaysTemplate)
                volumeButton.setImage(volumeImage, for: .normal)
                volumeButton.tintColor = UIColor.black
            }
            
            controlBarToBottom.constant = 30
            slideToControlBar.constant = 30
            
            navigationController?.navigationBar.isHidden = false
        }
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
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours, minutes, seconds])
        } else {
            return String(format: "%02i:%02i", arguments: [minutes, seconds])
        }
    }
    
    @IBAction func setVolume(_ sender: Any) {
        if player.volume == 0 {
            player.volume = 1
            volumeButton.setImage(UIImage(named: Constants.volumeUp), for: .normal)
        } else {
            player.volume = 0
            volumeButton.setImage(UIImage(named: Constants.volumeOff), for: .normal)
        }
    }
}
