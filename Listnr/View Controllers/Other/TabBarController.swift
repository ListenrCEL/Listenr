//
//  TabBarController.swift
//  Listnr
//
//  Created by Oliver Moscow on 11/5/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    @IBOutlet var playerView: UIView!
    @IBOutlet weak var bottomPlayerView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var coverArt: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        playerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerView)
        NSLayoutConstraint.activate([
            playerView.bottomAnchor.constraint(equalTo: self.tabBar.topAnchor),
            playerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            playerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        if userInterfaceStyle == .dark {
            forwardButton.tintColor = .lightGray
            backButton.tintColor = .lightGray
        } else {
            forwardButton.tintColor = .darkGray
            backButton.tintColor = .darkGray
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentPlayer), name: Notification.Name("presentPlayer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentNewCollection), name: Notification.Name("newCollection"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupPlayer), name: Notification.Name("updatingPlayer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentSelectedCellDetail), name: Notification.Name("presentSelectedCellDetail"), object: nil)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let userInterfaceStyle = traitCollection.userInterfaceStyle
        if userInterfaceStyle == .dark {
            forwardButton.tintColor = .lightGray
            backButton.tintColor = .lightGray
        } else {
            forwardButton.tintColor = .darkGray
            backButton.tintColor = .darkGray
        }
    }
    @objc func presentNewCollection() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "newCollection") as! NewCollectionViewController
        self.present(vc, animated: true, completion: nil)
    }
    @objc func presentPlayer() {
        performSegue(withIdentifier: "playerView", sender: self)
    }
    @objc func presentSelectedCellDetail() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SelectedCellDetailViewController") as! SelectedCellDetailViewController
        self.present(vc, animated: true, completion: nil)
    }
    @objc func setupPlayer() {
        if AudioPlayer.shared.queue.count == 0 {
            creator.isHidden = true
            titleLabel.text = "Not Playing"
            coverArt.image = nil
        } else {
            creator.isHidden = false
            if AudioPlayer.shared.queue.first?.currentStory.anonomous == true {
                coverArt.image = UIImage(named: "Anonymous")
                titleLabel.text = AudioPlayer.shared.queue[0].currentStory.title
                creator.text = "Anonymous"
            } else {
                coverArt.image = AudioPlayer.shared.queue[0].currentStory.coverArt
                titleLabel.text = AudioPlayer.shared.queue[0].currentStory.title
                creator.text = AudioPlayer.shared.queue[0].currentStory.creator.name
            }
            if !AudioPlayer.shared.isPlaying {
                playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            } else {
                playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            }
        }
    }
    @IBAction func didTapPlayer(_ sender: UITapGestureRecognizer) {
        presentPlayer()
    }
    
    @IBAction func playPressed(_ sender: UIButton) {
        guard AudioPlayer.shared.queue.count != 0 else {return}
        if !AudioPlayer.shared.isPlaying {
            AudioPlayer.shared.isPlaying = true
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        } else {
            AudioPlayer.shared.isPlaying = false
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        }
    }
    @IBAction func skipPressed(_ sender: UIButton) {
        AudioPlayer.shared.next()
    }
    @IBAction func backPressed(_ sender: UIButton) {
        AudioPlayer.shared.back()
    }
}
