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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(playerView)
        NSLayoutConstraint.activate([
            playerView.bottomAnchor.constraint(equalTo: self.tabBar.topAnchor),
            playerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            playerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 90)
        ])
        NotificationCenter.default.addObserver(self, selector: #selector(presentPlayer), name: Notification.Name("presentPlayer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentNewCollection), name: Notification.Name("newCollection"), object: nil)
    }
    @objc func player() {
        if !AudioPlayer.shared.isPlaying {
            AudioPlayer.shared.isPlaying = true
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            AudioPlayer.shared.isPlaying = false
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
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
    @IBAction func didTapPlayer(_ sender: UITapGestureRecognizer) {
        presentPlayer()
    }
    
    @IBAction func playPressed(_ sender: UIButton) {
        player()
    }
}
