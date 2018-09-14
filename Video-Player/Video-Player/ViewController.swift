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
    @IBOutlet weak var inputUrlTextField: UITextField!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var volumeButton: UIButton!
    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var videoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchButton.layer.cornerRadius = 5
        searchButton.layer.borderColor = UIColor(red: 185/255, green: 185/255, blue: 185/255, alpha: 1).cgColor
        searchButton.layer.borderWidth = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func playVideo(_ sender: Any) {
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

