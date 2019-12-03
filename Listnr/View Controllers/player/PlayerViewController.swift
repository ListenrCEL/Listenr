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

    //MARK: -Outlets
    @IBOutlet weak var coverArt: UIImageView!
    @IBOutlet weak var storyTitle: UILabel!
    @IBOutlet weak var creatorLabel: UIButton!
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
    @IBOutlet weak var collectionTitle: UIButton!
    @IBOutlet var background: UIView!
    @IBOutlet weak var coverArtContainerView: UIView!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
        NotificationCenter.default.addObserver(self, selector: #selector(setupPlayer), name: Notification.Name("updatingPlayer"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCollectionView" {
            let nvc = segue.destination as! CollectionTableViewController
            nvc.content = AudioPlayer.shared.queue.first!.currentCollection
        }
    }
    func loadStory() {
        if AudioPlayer.shared.queue.count == 0 {
            noStory()
        } else {
            let story = AudioPlayer.shared.queue.first?.currentStory
            coverArt.image = story?.coverArt
            storyTitle.text = story?.title
            creatorLabel.setTitle(story?.creator.name, for: .normal)
        }
        coverArtContainerView.layer.shadowColor = UIColor.black.cgColor
        coverArtContainerView.layer.shadowRadius = 30
        coverArtContainerView.layer.shadowOpacity = 1
        coverArtContainerView.layer.shadowOffset = .zero
        background.backgroundColor = coverArt.image?.averageColor

        if (background.backgroundColor?.isLight())! {
            overrideUserInterfaceStyle = .light
        } else {
            overrideUserInterfaceStyle = .dark
        }
    }
    func noStory() {
        coverArt.image = nil
        collectionTitle.setTitle("Not Playing", for: .normal)
        creatorLabel.setTitle("-------", for: .normal)
        storyTitle.text = "Not Playing"
        currentTimeLabel.text = "--:--"
        totalTimeLabel.text = "--:--"
    }
    
    //MARK: - Actions
    @IBAction func playPressed(_ sender: Any) {
        guard AudioPlayer.shared.queue.count != 0 else { return }
        if !AudioPlayer.shared.isPlaying {
            AudioPlayer.shared.isPlaying = true
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        } else {
            AudioPlayer.shared.isPlaying = false
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        }
    }
    @objc func setupPlayer() {
        guard AudioPlayer.shared.queue.count != 0 else {noStory(); return}
        loadStory()
        collectionTitle.setTitle(AudioPlayer.shared.queue[0].currentCollection.title, for: .normal)
        if AudioPlayer.shared.isPlaying {
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        } else {
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        }
        slider.maximumValue = Float(AudioPlayer.shared.audioPlayer!.duration)
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        totalTimeLabel.text = String(format: "%02d:%02d", ((Int)((AudioPlayer.shared.audioPlayer!.duration))) / 60, ((Int)((AudioPlayer.shared.audioPlayer!.duration))) % 60)
    }
    
    @objc func updateSlider() {
        guard AudioPlayer.shared.audioPlayer != nil else {
            slider.value = 0
            noStory()
            return
        }
        slider.value = Float(AudioPlayer.shared.audioPlayer!.currentTime)
        currentTimeLabel.text = String(format: "%02d:%02d", ((Int)((AudioPlayer.shared.audioPlayer!.currentTime))) / 60, ((Int)((AudioPlayer.shared.audioPlayer!.currentTime))) % 60)
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
        guard AudioPlayer.shared.audioPlayer != nil else {
            slider.value = 0
            noStory()
            return
        }
        AudioPlayer.shared.audioPlayer?.stop()
        AudioPlayer.shared.audioPlayer?.currentTime = TimeInterval(slider.value)
        AudioPlayer.shared.isPlaying = true
    }
    @IBAction func collectionPressed(_ sender: UIButton) {
        guard AudioPlayer.shared.queue.count != 0 else {return}
        performSegue(withIdentifier: "toCollectionView", sender: self)    }
    @IBAction func exitPressed(_ sender: Any) {
        dismiss(animated: true) {
        }
    }
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        exitPressed(self)
    }
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
//        AudioPlayer.shared.back()
    }
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
//        AudioPlayer.shared.next()
    }
    @IBAction func creatorPressed(_ sender: UIButton) {
        guard AudioPlayer.shared.queue.count != 0 else {return}
        performSegue(withIdentifier: "toProfile", sender: self)
        profileUser = (AudioPlayer.shared.queue.first?.currentStory.creator)!
    }
    
}
