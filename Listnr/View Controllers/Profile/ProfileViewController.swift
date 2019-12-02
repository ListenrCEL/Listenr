//
//  ProfileViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 10/22/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit
var newCollectionArray: [story] = []
var profileViewer = User()

class ProfileViewController: UITableViewController {
    
    // MARK: Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var username: UIButton!
    @IBOutlet var myTableView: UITableView!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    
    var randomColor: [[UIColor]] = generateRandomData()
    var selectedCollection = collection()
    var stories: [story] = []
    var collections: [collection] = []
    
    
    // MARK: - Edit
    var edit = false {
        willSet(newValue) {
            if newValue == true {
                tableView.isEditing = true
                let delete = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(deletePressed(_:)))
                let newCollection = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(newCollectionPressed(_:)))
                let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed(_:)))
                navigationItem.rightBarButtonItems = [delete, newCollection]
                navigationItem.leftBarButtonItems = [done]
            } else {
                tableView.isEditing = false
                setupPage()
            }
        }
    }
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPage()
        navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("reload"), object: nil)
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
    // MARK: - setupPage
    func setupPage() {
        if profileViewer.username == userData.data.username {
            profileViewer = userData.data
            let edit = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editPressed(_:)))
//            let settings = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(settingsPressed))
            navigationItem.rightBarButtonItems = [edit]
            navigationItem.leftBarButtonItems = []
            subscribeButton.isHidden = true
        } else {
            // if viewer is not the same as the profile user
            //seting up subscribed
            for index in 0 ..< userData.subscribedUsers.count {
                if userData.subscribedUsers[index].sUser.username == profileViewer.username {
                    subscribeButton.setTitle("Unsubscribe", for: .normal)
                    userData.subscribedUsers[index].new = false
                }
            }
            // seting up recents
            let insert = recentCollection(rCollection: collection(stories: profileViewer.stories, title: profileViewer.name, creator: profileViewer, coverArt: profileViewer.profileImage), isProfile: true)
            var canInsert: Bool = true
            if userData.recentCollections.count == 0 {
                userData.recentCollections.insert(insert, at: 0)
            } else {
                for n in 0 ..< userData.recentCollections.count {
                    if userData.recentCollections[n].rCollection.creator.username == profileViewer.username {
                        canInsert = false
                    }
                }
                if canInsert == true {
                    userData.recentCollections.insert(insert, at: 0)
                }
            }
            
            
            subscribeButton.isHidden = false
            let ellipsis = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(morePressed))
            navigationItem.leftBarButtonItems = []
            navigationItem.rightBarButtonItems = [ellipsis]
            navigationItem.title = profileViewer.name
            NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
        }
        let color = profileViewer.profileImage.averageColor
        if (color?.isLight())! {
            nameLabel.textColor = .black
            username.titleLabel?.textColor = .black
            subscribeButton.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.26)
        } else {
            nameLabel.textColor = .white
            username.titleLabel?.textColor = .white
        }
        
        profileImageView.image = profileViewer.profileImage
        nameLabel.text = profileViewer.name
        username.setTitle(profileViewer.username, for: .normal)
        collections = profileViewer.collections
        stories = profileViewer.stories
    }
    //MARK: - Actions
    @objc func reload() {
        if profileViewer.username == userData.data.username {
            profileViewer = userData.data
        }
        tableView.reloadData()
    }
    @objc func editPressed(_ sender: Any) {
        self.tableView.reloadData()
        edit = true
    }
    @IBAction func subscribePressed(_ sender: Any) {
        if subscribeButton.titleLabel?.text == "Subscribe" {
            userData.subscribedUsers.append(subscribedUser(sUser: profileViewer, new: false))
            subscribeButton.setTitle("Unsubscribe", for: .normal)
        } else {
            for n in 0 ..< userData.subscribedUsers.count {
                if userData.subscribedUsers[n].sUser.username == profileViewer.username {
                    userData.subscribedUsers.remove(at: n)
                    subscribeButton.setTitle("Subscribe", for: .normal)
                }
            }
        }
        NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
    }
    @objc func settingsPressed() {
    }
    @objc func morePressed() {
        
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
                    userData.data = profileViewer
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
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        
        label.frame = CGRect(x: 5, y: 5, width: 200, height: 30)
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.textColor = .darkGray
        
        let sectionTitles = ["Collections","Stories"]
        if profileViewer.stories.count == 0 && profileViewer.collections.count == 0 {
            label.text = "Add Stories"
            view.addSubview(label)
        } else {
            label.text = sectionTitles[section]
            view.addSubview(label)
        }
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let noCollections: [Int] = [0, 35]
        if profileViewer.collections.count == 0 {
            return CGFloat(noCollections[section])
        } else {
            return 35
            
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
            cell.creator.text = profileViewer.collections[indexPath.row].creator.name
            cell.coverArt.image = profileViewer.collections[indexPath.row].coverArt
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = backgroundView
            cell.titleLabel.text = profileViewer.stories[indexPath.row].title
            cell.creatorLabel.text = profileViewer.stories[indexPath.row].creator.name
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
        userData.data.stories = profileViewer.stories
    }
    //MARK: did select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard edit != true else { return }
        if indexPath.section == 0 {
            selectedCollection = profileViewer.collections[indexPath.row]
            performSegue(withIdentifier: "toCollection", sender: self)
        } else {
            guard AudioPlayer.shared.queue.first?.currentStory.storyURl != profileViewer.stories[indexPath.row].storyURl else { return }
            AudioPlayer.shared.queue = []
            AudioPlayer.shared.queue = [(queueItem(currentStory: profileViewer.stories[indexPath.row], currentCollection: collection(stories: profileViewer.stories, title: "Stories from \(profileViewer.name)", creator: profileViewer)))]
            AudioPlayer.shared.isPlaying = true
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
