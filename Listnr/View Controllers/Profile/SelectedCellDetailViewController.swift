//
//  SelectedCellDetailViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 12/25/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit
import AVFoundation

var selectedCellDetailStory = story()
var selectedCellDetailQueue: [queueItem] = []

class SelectedCellDetailViewController: UIViewController {
    
    @IBOutlet weak var coverArt: UIImageView!
    @IBOutlet weak var storyTitle: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedCellDetailStory.anonomous == true {
            coverArt.image = UIImage(named: "Anonymous")
            creatorLabel.text = "Anonymous"
        } else {
            coverArt.image = selectedCellDetailStory.coverArt
            creatorLabel.text = selectedCellDetailStory.creator.name
        }
        storyTitle.text = selectedCellDetailStory.title
        let asset = AVURLAsset.init(url: selectedCellDetailStory.storyURl.absoluteURL, options: nil)
        let audioDuration = CMTimeGetSeconds(asset.duration)
        if audioDuration <= 1000 {
            timeLabel.text = String(format: "%2d:%02d", ((Int)((audioDuration))) / 60, ((Int)((audioDuration))) % 60)
        } else {
            timeLabel.text = String(format: "%02d:%02d", ((Int)((audioDuration))) / 60, ((Int)((audioDuration))) % 60)
        }
    }
    @IBAction func playPressed(_ sender: Any) {
        AudioPlayer.shared.isPlaying = false
        AudioPlayer.shared.audioPlayer?.stop()
        AudioPlayer.shared.queue = []
        for n in 0 ..< selectedCellDetailQueue.count {
            AudioPlayer.shared.queue.append(selectedCellDetailQueue[n])
        }
        AudioPlayer.shared.isPlaying = true
        dismiss(animated: true) {
            NotificationCenter.default.post(name: Notification.Name("presentPlayer"), object: nil)
        }
    }
    @IBAction func PanGesture(_ sender: UIPanGestureRecognizer) {
    }
    @IBAction func didSipe(_ sender: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
