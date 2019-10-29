//
//  ProfileViewController.swift
//  Listenr
//
//  Created by Oliver Moscow on 10/22/19.
//  Copyright © 2019 Listenr. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var randomColor: [[UIColor]] = generateRandomData()
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // calls from SetUpProfilePage.swift
        setUpProfilePage()
        
        profileImageView.backgroundColor = randomColor[1][1]
        nameLabel.text = userData.name
        usernameLabel.text = userData.username
        
        let size = profileImageView.bounds.width
        profileImageView.layer.cornerRadius = size/2
        profileImageView.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
        cell.titleLabel.text = userData.stories[indexPath.row].title
        cell.creatorLabel.text = userData.stories[indexPath.row].creator
        // TODO - replace this with real images from the web
        cell.profileImage.backgroundColor = randomColor[0][indexPath.row]
        return cell
    }
}
