//
//  ProfileViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 10/22/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit
import AVFoundation
var newCollectionArray: [story] = []
var profileUser = User()

class ProfileViewController: UITableViewController {
    
    // MARK: Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var username: UIButton!
    @IBOutlet var myTableView: UITableView!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var subsLabel: UILabel!
    @IBOutlet weak var subsIcon: UIImageView!
    
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
        subsLabel.text = String(profileUser.subscribers)
        if profileUser.username == userData.data.username {
            profileUser = userData.data
            let edit = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editPressed(_:)))
//            let settings = UIBarButtonItem(image: UIImage(named: "settings"), style: .plain, target: self, action: #selector(settingsPressed))
            navigationItem.rightBarButtonItems = [edit]
            navigationItem.leftBarButtonItems = []
            subscribeButton.isHidden = true
        } else {
            // if viewer is not the same as the profile user
            //seting up subscribed
            for index in 0 ..< userData.subscribedUsers.count {
                if userData.subscribedUsers[index].sUser.username == profileUser.username {
                    subscribeButton.setTitle("Unsubscribe", for: .normal)
                    userData.subscribedUsers[index].new = false
                }
            }
            // seting up recents
            let insert = recentCollection(rCollection: collection(stories: profileUser.stories, title: profileUser.name, creator: profileUser, coverArt: profileUser.profileImage), isProfile: true)
            if userData.recentCollections.count == 0 {
                userData.recentCollections.insert(insert, at: 0)
            } else {
                for n in 0 ..< userData.recentCollections.count {
                    if userData.recentCollections[n].rCollection.creator.username == profileUser.username {
                        userData.recentCollections.remove(at: n)
                        break
                    }
                }
                userData.recentCollections.insert(insert, at: 0)
            }
            
            
            subscribeButton.isHidden = false
            let ellipsis = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(morePressed))
            navigationItem.leftBarButtonItems = []
            navigationItem.rightBarButtonItems = [ellipsis]
            navigationItem.title = profileUser.name
            NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
        }
        let color = profileUser.profileImage.averageColor
        if ((color?.isLight() ?? false)) {
            nameLabel.textColor = .black
            username.titleLabel?.textColor = .black
            subscribeButton.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.26)
            subsLabel.textColor = .black
            subsIcon.tintColor = .black
        }
        
        profileImageView.image = profileUser.profileImage
        nameLabel.text = profileUser.name
        username.setTitle(profileUser.username, for: .normal)
        collections = profileUser.collections
        stories = profileUser.stories
    }
    //MARK: - Actions
    @objc func reload() {
        if profileUser.username == userData.data.username {
            profileUser = userData.data
        }
        tableView.reloadData()
    }
    @objc func editPressed(_ sender: Any) {
        self.tableView.reloadData()
        edit = true
    }
    @IBAction func subscribePressed(_ sender: Any) {
        if subscribeButton.titleLabel?.text == "Subscribe" {
            userData.subscribedUsers.append(subscribedUser(sUser: profileUser, new: false))
            profileUser.subscribers += 1
            subsLabel.text = String(profileUser.subscribers)
            subscribeButton.setTitle("Unsubscribe", for: .normal)
            NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
        } else {
            for n in 0 ..< userData.subscribedUsers.count {
                if userData.subscribedUsers[n].sUser.username == profileUser.username {
                    userData.subscribedUsers.remove(at: n)
                    profileUser.subscribers -= 1
                    subsLabel.text = String(profileUser.subscribers)
                    subscribeButton.setTitle("Subscribe", for: .normal)
                    NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
                    return
                }
            }
        }
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
                        profileUser.collections.remove(at: indexPath.row)
                    } else {
//                        for x in 0 ..< users.count {
//                            for y in 0 ..< users[x].collections.count {
//                                for z in 0 ..< users[x].collections[y].stories.count {
//                                    // TODO - change to audioids when everystory is custom
//                                    if users[x].collections[y].stories[z].title == profileUser.stories[indexPath.row].title {
//                                        users[x].collections[y].stories.remove(at: z)
//                                        break
//                                    }
//                                }
//                            }
//                        }
                        profileUser.stories.remove(at: indexPath.row)
                        userData.data = profileUser
//                        profileUser.collections = userData.data.collections
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
                if profileUser.collections.count == 0 {
                    newCollectionArray.append(profileUser.stories[indexPath.row])
                } else {
                    guard indexPath.section != 0 else {return}
                    newCollectionArray.append(profileUser.stories[indexPath.row])
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
        if profileUser.stories.count == 0 && profileUser.collections.count == 0 {
            if profileUser.username == userData.data.username {
                label.text = "Add Stories"
            } else {
                label.text = "No Stories"
            }
            
            view.addSubview(label)
        } else {
            label.text = sectionTitles[section]
            view.addSubview(label)
        }
        return view
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let noCollections: [Int] = [0, 35]
        if profileUser.collections.count == 0 {
            return CGFloat(noCollections[section])
        } else {
            return 35
            
        }
    }
    //MARK: numberOfRows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return profileUser.collections.count
        } else {
            return profileUser.stories.count
        }
    }
    //MARK: cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfileTableViewCell2
            cell.title.text = profileUser.collections[indexPath.row].title
            cell.creator.text = profileUser.collections[indexPath.row].creator.name
            cell.coverArt.image = profileUser.collections[indexPath.row].coverArt
            if profileUser.username == userData.data.username {
                cell.viewsStackView.isHidden = false
                cell.viewsLabel.text = String(profileUser.collections[indexPath.row].views)
            } else {
                cell.viewsStackView.isHidden = true
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProfileTableViewCell
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.clear
            cell.selectedBackgroundView = backgroundView
            if profileUser.stories[indexPath.row].anonomous == false {
                cell.titleLabel.text = profileUser.stories[indexPath.row].title
                cell.creatorLabel.text = profileUser.stories[indexPath.row].creator.name
                cell.profileImage.image = profileUser.stories[indexPath.row].coverArt
            } else {
                cell.titleLabel.text = profileUser.stories[indexPath.row].title
                cell.creatorLabel.text = "Anonymous"
                cell.profileImage.image = UIImage(named: "Anonymous")
            }
            // audio duration
            let asset = AVURLAsset.init(url: profileUser.stories[indexPath.row].storyURl.absoluteURL, options: nil)
            let audioDuration = CMTimeGetSeconds(asset.duration)
            if audioDuration <= 1000 {
                cell.timeLabel.text = String(format: "%2d:%02d", ((Int)((audioDuration))) / 60, ((Int)((audioDuration))) % 60)
            } else {
                cell.timeLabel.text = String(format: "%02d:%02d", ((Int)((audioDuration))) / 60, ((Int)((audioDuration))) % 60)
            }
            //Views
            if profileUser.username == userData.data.username {
                cell.viewsLabel.isHidden = false
                cell.viewsLabel.text = String(profileUser.stories[indexPath.row].views)
                cell.viewsIcon.isHidden = false
            } else {
                cell.viewsLabel.isHidden = true
                cell.viewsIcon.isHidden = true
            }
            return cell
        }
    }
    //MARK: hight
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 75
        } else {
            if profileUser.stories[indexPath.row].anonomous == true {
                if profileUser.username != userData.data.username {
                    return 0
                }
            }
            return 60
        }
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObjTemp = profileUser.stories[sourceIndexPath.item]
        profileUser.stories.remove(at: sourceIndexPath.item)
        profileUser.stories.insert(movedObjTemp, at: destinationIndexPath.item)
        userData.data.stories = profileUser.stories
    }
    //MARK: did select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard edit != true else { return }
        if indexPath.section == 0 {
            selectedCollection = profileUser.collections[indexPath.row]
            performSegue(withIdentifier: "toCollection", sender: self)
        } else {
            //            guard AudioPlayer.shared.queue.first?.currentStory.storyURl != profileUser.stories[indexPath.row].storyURl else { return }
            selectedCellDetailQueue = []
            for n in indexPath.row ..< profileUser.stories.count {
                if profileUser.stories[n].anonomous == true {
                    if profileUser.username == userData.data.username {
                        selectedCellDetailQueue.append((queueItem(currentStory: profileUser.stories[n], currentCollection: collection(stories: [], title: "Stories from \(profileUser.name)", creator: profileUser), profile: true)))
                    }
                } else {
                    selectedCellDetailQueue.append((queueItem(currentStory: profileUser.stories[n], currentCollection: collection(stories: [], title: "Stories from \(profileUser.name)", creator: profileUser), profile: true)))
                }
            }
            selectedCellDetailStory = profileUser.stories[indexPath.row]
            NotificationCenter.default.post(name: Notification.Name("presentSelectedCellDetail"), object: nil)
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
