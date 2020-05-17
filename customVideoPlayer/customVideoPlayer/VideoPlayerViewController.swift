//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Ali Şengür on 15.01.2020.
//  Copyright © 2020 Ali Şengür. All rights reserved.
//

import UIKit
import AVFoundation


class VideoPlayerViewController: UIViewController {
    
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet private weak var pausePlayButton: UIButton!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var previousVideoButton: UIButton!
    @IBOutlet weak var nextVideoButton: UIButton!
    @IBOutlet weak var videoTimeSlider: UISlider!
    @IBOutlet weak var fullScreenButton: UIButton!
    
    
    //MARK: -Properties
    var queuePlayer: AVQueuePlayer!   // created AVQueuePlayer object
    var playerLayer: AVPlayerLayer!   // AVPlayerLayer object is created.
    var isFullscreen: Bool = false
    var isPlaying: Bool {  // this variable controls player state whether it is paused or playing
        return queuePlayer.rate != 0 && queuePlayer.error == nil
    }
    var videos: [String] = []
    var video: String!
    private var playerItems: [AVPlayerItem] = []
    private var playerItem: AVPlayerItem?
    private var tempIndex = 0
    private var token: NSKeyValueObservation?
    
    
    

    
    
    
    //MARK: -Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        hideControls()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startVideos(videos: videos)
        let tapView = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        videoView.addGestureRecognizer(tapView)
        hideControls()
        setControls()
        self.tempIndex = self.playerItems.endIndex-1
    }
    
    func setControls() {
        videoTimeSlider.minimumTrackTintColor = UIColor.link
        videoTimeSlider.thumbTintColor = UIColor.link
        videoTimeSlider.maximumTrackTintColor = UIColor.white
        pausePlayButton.tintColor = UIColor.white
        nextVideoButton.tintColor = UIColor.white
        previousVideoButton.tintColor = UIColor.white
        fullScreenButton.tintColor = UIColor.white
        currentTimeLabel.textColor = UIColor.white
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        queuePlayer.pause()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let pl = playerLayer {
            pl.frame = videoView.bounds
        }
    }
    
    
    

    @IBAction func timeSliderChanged(_ sender: Any) {
        print(videoTimeSlider.value)
        if let duration = queuePlayer.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoTimeSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            queuePlayer.seek(to: seekTime, completionHandler: {(completedSeek)
                in
            })
        }
    }
    
    
    
    func hideControls() {
        navigationController?.isNavigationBarHidden = true
        pausePlayButton.isHidden = true
        videoTimeSlider.isHidden = true
        currentTimeLabel.isHidden = true
        previousVideoButton.isHidden = true
        nextVideoButton.isHidden = true
        fullScreenButton.isHidden = true
        videoView.addSubview(pausePlayButton)
        videoView.addSubview(videoTimeSlider)
        videoView.addSubview(currentTimeLabel)
        videoView.addSubview(previousVideoButton)
        videoView.addSubview(nextVideoButton)
        videoView.addSubview(fullScreenButton)
    }
    

    
    //MARK: -User Functions
    @IBAction func pausePlayButtonClicked(_ sender: UIButton) {
        updateUI()
    }
    
    
    @IBAction func previousButtonClicked(_ sender: UIButton) {
        
        for _ in 0..<videos.count-1 {
            queuePlayer.advanceToNextItem()
        }
    }
    

    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
    
        self.queuePlayer?.advanceToNextItem()
    }
    
    
    @IBAction func fullScreenTapped(_ sender: Any) {
        if isFullscreen { AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
            isFullscreen = !isFullscreen
        } else { AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
            isFullscreen = !isFullscreen
        }
    }
    
    
    @objc func viewTapped() {
        navigationController!.isNavigationBarHidden = !navigationController!.isNavigationBarHidden
        pausePlayButton.isHidden = !pausePlayButton.isHidden
        videoTimeSlider.isHidden = !videoTimeSlider.isHidden
        //videoLengthLabel.isHidden = !isTapped
        currentTimeLabel.isHidden = !currentTimeLabel.isHidden
        previousVideoButton.isHidden = !previousVideoButton.isHidden
        nextVideoButton.isHidden = !nextVideoButton.isHidden
        fullScreenButton.isHidden = !fullScreenButton.isHidden
    }
    
    
    func updateUI() {  // when tapped pausePlayButton, updates the UI
        if isPlaying {
            queuePlayer.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            queuePlayer.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    
    
    func startVideos(videos: [String]) {
        
        queuePlayer = AVQueuePlayer()
        playerLayer = AVPlayerLayer(player: queuePlayer)

        
        guard let playerLayer = playerLayer else { fatalError("Error creating player layer") }
        playerLayer.frame = view.layer.bounds
        playerLayer.videoGravity = .resize
        videoView.layer.addSublayer(playerLayer)
        
        addVideos(videos: self.videos)
        
        
        let interval = CMTime(value: 1, timescale: 2)
        queuePlayer.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: {(progressTime)
            in
            let seconds = CMTimeGetSeconds(progressTime)
            let secondsString = String(format: "%02d", Int(seconds) % 60)
            let minutesString = String(format: "%02d", Int(seconds) / 60)
            self.currentTimeLabel.text = "\(minutesString):\(secondsString)"  // set the current time label

            
            
            if let duration = self.queuePlayer.currentItem?.duration {
                let durationSeconds = CMTimeGetSeconds(duration)
                self.videoTimeSlider.value = Float(seconds / durationSeconds)
            }
            
        })
        
        self.queuePlayer.play()
        
        self.token = self.queuePlayer!.observe(\.currentItem) { [weak self] player, _ in
            if self!.queuePlayer.items().count == 1 {
                self?.addVideos(videos: (self?.videos)!)
            }
            
        }
    }
    
    
    
    func addVideos(videos: [String]) {
        for video in videos {
            guard let path = Bundle.main.path(forResource: "\(video)", ofType: "mp4") else { return }
            let url = URL(fileURLWithPath: path)
            let asset = AVAsset(url: url)
            let item = AVPlayerItem(asset: asset)
            
            queuePlayer.insert(item, after: queuePlayer.items().last)
        }
        
        
    }

}
