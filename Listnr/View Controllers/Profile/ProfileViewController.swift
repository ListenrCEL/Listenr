//
//  ProfileViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 10/22/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit
var newCollectionArray: [story] = []

class ProfileViewController: UITableViewController {
    
    // MARK: Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet var myTableView: UITableView!
    @IBOutlet weak var newStoryButton: UIButton!
    
    var randomColor: [[UIColor]] = generateRandomData()
    var selectedCollection = collection()
    
    var sectionTitles = ["Collections","Stories"]
    var sectionHights: [Int] = [0, 25]
    // MARK: - Edit
    var edit = false {
        willSet(newValue) {
            if newValue == true {
                tableView.isEditing = true
                newStoryButton.isHidden = true
                editButton.isHidden = true
                
                let delete = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(deletePressed(_:)))
                let newCollection = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(newCollectionPressed(_:)))
                let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed(_:)))
                navigationItem.rightBarButtonItems = [delete, newCollection]
                navigationItem.leftBarButtonItems = [done]
            } else {
                tableView.isEditing = false
                newStoryButton.isHidden = false
                editButton.isHidden = false
                navigationItem.rightBarButtonItems = []
                navigationItem.leftBarButtonItems = []
            }
        }
    }
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // calls from SetUpProfilePage.swift
        // FIREBASE - upload userstories to userData.stories (userData.stories)
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCollection" {
            let nvc = segue.destination as! CollectionTableViewController
            nvc.content = selectedCollection
        }
    }
    
    
    //MARK: Actions
    @IBAction func editPressed(_ sender: UIButton) {
        self.tableView.reloadData()
        edit = true
    }
    @IBAction func newStoryPressed(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NewStoryNavBar") as! NewStoryNavBar
        self.present(vc, animated:true, completion:nil)
    }
    //MARK: Delete
    @objc func deletePressed(_ sender: UIBarButtonItem) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            let alertController = UIAlertController(title: "Are you sure you want to delete?", message: "This action cannot be undone", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                for indexPath in selectedRows  {
                    if indexPath.section == 0 {
                        print(indexPath.row)
                        userData.collections.remove(at: indexPath.row)
                    } else {
                        userData.stories.remove(at: indexPath.row)
                    }
                }
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: selectedRows, with: .automatic)
                self.tableView.endUpdates()
                alertController.dismiss(animated: true)
            }))
            alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
                alertController.dismiss(animated: true)
            }))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    //MARK: New Collection
    @objc func newCollectionPressed(_ sender: Any) {
        newCollectionArray = []
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows  {
                if userData.collections.count == 0 {
                    newCollectionArray.append(userData.stories[indexPath.row])
                } else {
                    guard indexPath.section != 0 else {return}
                    newCollectionArray.append(userData.stories[indexPath.row])
                }
            }
            guard newCollectionArray.count != 0 else {return}
            edit = false
            NotificationCenter.default.post(name: Notification.Name("newCollection"), object: nil)
        }
    }
    @objc func donePressed(_ sender: UIBarButtonItem) {
        self.tableView.reloadData()
        edit = false
    }
}
//MARK: - TableViewController

extension ProfileViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    //MARK: Header
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if userData.collections.count == 0 {
            return CGFloat(sectionHights[section])
        } else {
            return 25
        }
    }
    //MARK: numberOfRows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return userData.collections.count
        } else {
            return userData.stories.count
        }
    }
    //MARK: cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfileTableViewCell2
            cell.title.text = userData.collections[indexPath.row].title
            cell.creator.text = userData.collections[indexPath.row].creator
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = backgroundView
            cell.titleLabel.text = userData.stories[indexPath.row].title
            cell.creatorLabel.text = userData.stories[indexPath.row].creator
            cell.profileImage.image = userData.stories[indexPath.row].coverArt
            return cell
        }
    }
    //MARK: hight
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 75
        } else {
            return 60
        }
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObjTemp = userData.stories[sourceIndexPath.item]
        userData.stories.remove(at: sourceIndexPath.item)
        userData.stories.insert(movedObjTemp, at: destinationIndexPath.item)
    }
    //MARK: did select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard edit != true else { return }
        if indexPath.section == 0 {
            selectedCollection = userData.collections[indexPath.row]
            performSegue(withIdentifier: "toCollection", sender: self)
        } else {
            AudioPlayer.shared.audioURl = userData.stories[indexPath.row].storyURl
            if !AudioPlayer.shared.isPlaying {
                AudioPlayer.shared.isPlaying = true
            } else {
                AudioPlayer.shared.isPlaying = false
            }
        }
    }
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
            }
            return NSIndexPath(row: row, section: sourceIndexPath.section) as IndexPath
        }
        return proposedDestinationIndexPath
    }
}
