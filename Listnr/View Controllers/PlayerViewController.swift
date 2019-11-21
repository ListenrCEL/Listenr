//
//  PlayerViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 11/6/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

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
        if AudioPlayer.shared.isPlaying == false {
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if isBeingDismissed {
            print("dismissing")
//            TabBarController.perform(#selector(TabBarController.player))
        }
    }
    //MARK: - Actions
    @IBAction func playPressed(_ sender: UIButton) {
        if !AudioPlayer.shared.isPlaying {
            AudioPlayer.shared.isPlaying = true
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            AudioPlayer.shared.isPlaying = false
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    @IBAction func backPressed(_ sender: UIButton) {
    }
    @IBAction func forwardPressed(_ sender: UIButton) {
    }
    @IBAction func back30Pressed(_ sender: UIButton) {
    }
    @IBAction func forward30Pressed(_ sender: UIButton) {
    }
    @IBAction func sliderChanged(_ sender: UISlider) {
    }
    
}
