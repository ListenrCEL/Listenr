//
//  ProfileViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 10/22/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit
var newCollectionArray: [story] = []
var profileViewer = user()

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
    var stories: [story] = []
    var collections: [collection] = []
    
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
        
        if profileViewer.username == userData.username {
            profileViewer = userData
        }
        profileImageView.backgroundColor = randomColor[1][1]
        nameLabel.text = profileViewer.name
        usernameLabel.text = profileViewer.username
        collections = profileViewer.collections
        stories = profileViewer.stories
        
        let size = profileImageView.bounds.width
        profileImageView.layer.cornerRadius = size/2
        profileImageView.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("reloadProfile"), object: nil)
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
    @objc func reload() {
        tableView.reloadData()
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
                        profileViewer.collections.remove(at: indexPath.row)
                    } else {
                        var index = 0
                        for _ in profileViewer.collections {
                            let item = profileViewer.collections[index].stories
                            if let i = item.firstIndex(where: {$0.storyURl == profileViewer.stories[indexPath.row].storyURl}) {
                                profileViewer.collections[index].stories.remove(at: i)
                            }
                            index += 1
                        }
                        profileViewer.stories.remove(at: indexPath.row)
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
                if profileViewer.collections.count == 0 {
                    newCollectionArray.append(profileViewer.stories[indexPath.row])
                } else {
                    guard indexPath.section != 0 else {return}
                    newCollectionArray.append(profileViewer.stories[indexPath.row])
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
        let sectionTitles = ["Collections","Stories"]
        if profileViewer.stories.count == 0 && profileViewer.collections.count == 0 {
            return "Add Stories"
        }
        return sectionTitles[section]
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let noCollections: [Int] = [0, 25]
        if profileViewer.collections.count == 0 {
            return CGFloat(noCollections[section])
        } else {
            return 25
        }
    }
    //MARK: numberOfRows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return profileViewer.collections.count
        } else {
            return profileViewer.stories.count
        }
    }
    //MARK: cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfileTableViewCell2
            cell.title.text = profileViewer.collections[indexPath.row].title
            cell.creator.text = profileViewer.collections[indexPath.row].creator
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = backgroundView
            cell.titleLabel.text = profileViewer.stories[indexPath.row].title
            cell.creatorLabel.text = profileViewer.stories[indexPath.row].creator
            cell.profileImage.image = profileViewer.stories[indexPath.row].coverArt
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
        let movedObjTemp = profileViewer.stories[sourceIndexPath.item]
        profileViewer.stories.remove(at: sourceIndexPath.item)
        profileViewer.stories.insert(movedObjTemp, at: destinationIndexPath.item)
    }
    //MARK: did select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard edit != true else { return }
        if indexPath.section == 0 {
            selectedCollection = profileViewer.collections[indexPath.row]
            performSegue(withIdentifier: "toCollection", sender: self)
        } else {
            AudioPlayer.shared.queue = []
            AudioPlayer.shared.queue = [(queueItem(currentStory: profileViewer.stories[indexPath.row], currentCollection: collection(stories: profileViewer.stories, title: "Stories from \(profileViewer.name)", creator: profileViewer.username), currentUser: profileViewer))]
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
