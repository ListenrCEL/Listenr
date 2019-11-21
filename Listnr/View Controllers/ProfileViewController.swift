//
//  ProfileViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 10/22/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    // MARK: Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet var myTableView: UITableView!
    var randomColor: [[UIColor]] = generateRandomData()
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // calls from SetUpProfilePage.swift
        // FIREBASE - upload userstories to userData.stories (userData.stories)
        
        setUpProfile()
        profileImageView.backgroundColor = randomColor[1][1]
        nameLabel.text = userData.name
        usernameLabel.text = userData.username
        
        let size = profileImageView.bounds.width
        profileImageView.layer.cornerRadius = size/2
        profileImageView.layer.masksToBounds = true

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        tableView.reloadData()
    }
    //MARK: TableViewController
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.stories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
        cell.titleLabel.text = userData.stories[indexPath.row].title
        cell.creatorLabel.text = userData.stories[indexPath.row].creator
        cell.profileImage.image = userData.stories[indexPath.row].coverArt
        return cell
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObjTemp = userData.stories[sourceIndexPath.item]
        userData.stories.remove(at: sourceIndexPath.item)
        userData.stories.insert(movedObjTemp, at: destinationIndexPath.item)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            userData.stories.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            print(userData.stories)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioPlayer.shared.audioURl = userData.stories[indexPath.row].storyURl
        if !AudioPlayer.shared.isPlaying {
            AudioPlayer.shared.isPlaying = true
        } else {
            AudioPlayer.shared.isPlaying = false
        }
    }
    
    
    //MARK: actions
    @IBAction func editPressed(_ sender: UIButton) {
        self.tableView.reloadData()
        self.tableView.isEditing = !self.tableView.isEditing
        if self.tableView.isEditing {
            editButton.setTitle("Done", for: .normal)
        } else {
            editButton.setTitle("Edit", for: .normal)
        }
    }
    @IBAction func newStoryPressed(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NewStoryNavBar") as! NewStoryNavBar
        self.present(vc, animated:true, completion:nil)
    }
}
