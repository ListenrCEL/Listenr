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
    }
    @objc func presentPlayer() {
        performSegue(withIdentifier: "playerView", sender: self)
    }
    @IBAction func didTapPlayer(_ sender: UITapGestureRecognizer) {
        presentPlayer()
    }
    
}
