//
//  PlayerViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 11/6/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class PlayerViewController: UIViewController {

    //MARK: Otlets
    @IBOutlet weak var coverArt: UIImageView!
    @IBOutlet weak var storyTitle: UILabel!
    @IBOutlet weak var creatorlabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var back30: UIButton!
    @IBOutlet weak var forward30: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        NotificationCenter.default.addObserver(self, selector: #selector(setupPlayer), name: Notification.Name("updatingPlayer"), object: nil)
    }
    func loadStory() {
        coverArt.layer.shadowColor = UIColor.black.cgColor
        coverArt.layer.shadowRadius = 30
        coverArt.layer.shadowOpacity = 0.5
        coverArt.layer.shadowOffset = CGSize(width: 0, height: 0)
        if AudioPlayer.shared.queue.count == 0 {
            // set up the nothing playing page
        } else {
            let story = AudioPlayer.shared.queue.first
            coverArt.image = story?.coverArt
            storyTitle.text = story?.title
            creatorlabel.text = story?.creator
        }
        
    }
    
    //MARK: - Actions
    @IBAction func playPressed(_ sender: Any) {
        if !AudioPlayer.shared.isPlaying {
            AudioPlayer.shared.isPlaying = true
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        } else {
            AudioPlayer.shared.isPlaying = false
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        }
    }
    @objc func setupPlayer() {
        loadStory()
        if AudioPlayer.shared.isPlaying {
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        } else {
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        }
        slider.maximumValue = Float(AudioPlayer.shared.audioPlayer!.duration)
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    @objc func updateSlider() {
        slider.value = Float(AudioPlayer.shared.audioPlayer!.currentTime)
    }
    @IBAction func backPressed(_ sender: UIButton) {
        AudioPlayer.shared.back()
    }
    @IBAction func forwardPressed(_ sender: UIButton) {
        AudioPlayer.shared.next()
    }
    @IBAction func back30Pressed(_ sender: UIButton) {
        AudioPlayer.shared.rewind()
    }
    @IBAction func forward30Pressed(_ sender: UIButton) {
        AudioPlayer.shared.fastForward()
    }
    @IBAction func sliderChanged(_ sender: UISlider) {
        AudioPlayer.shared.audioPlayer?.stop()
        AudioPlayer.shared.audioPlayer?.currentTime = TimeInterval(slider.value)
        AudioPlayer.shared.isPlaying = true
    }
    @IBAction func exitPressed(_ sender: UIButton) {
        dismiss(animated: true) {
            NotificationCenter.default.post(name: Notification.Name("updatingPlayer"), object: nil)
        }
    }
    
}
