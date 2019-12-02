//
//  CollectionTableViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 11/22/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class CollectionTableViewController: UITableViewController {
    
    var content = collection()
    @IBOutlet weak var creator: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var coverArt: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = content.title
        creator.setTitle(content.creator.name, for: .normal)
        coverArt.image = content.coverArt
        
        // TODO - uncoment this when all things arent made by urself
        //        if content.creator.username != userData.data.username {
        //            userData.recentCollections.append(content)
        //        }
        let insert = recentCollection(rCollection: content, isProfile: false)
        var canInsert: Bool = true
        if userData.recentCollections.count == 0 {
            userData.recentCollections.insert(insert, at:  0)
        } else {
            for n in 0 ..< userData.recentCollections.count {
                if userData.recentCollections[n].rCollection.title == content.title && userData.recentCollections[n].rCollection.creator.username == content.creator.username{
                    canInsert = false
                }
            }
            if canInsert == true {
                userData.recentCollections.insert(insert, at:  0)
            }
        }
        let color = content.coverArt.averageColor
        if (color?.isLight())! {
            titleLabel.textColor = .black
            creator.setTitleColor(.black, for: .normal)
        } else {
            titleLabel.textColor = .white
            creator.setTitleColor(.white, for: .normal)
        }
        
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = content.title
        NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupPlayer), name: Notification.Name("updatingPlayer"), object: nil)
        
    }
    //MARK: - tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.stories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CollectionTableViewCell
        cell.coverArt.image = content.stories[indexPath.row].coverArt
        cell.title.text = content.stories[indexPath.row].title
        cell.creator.text = content.stories[indexPath.row].creator.name
        cell.imageView?.bounds.size = cell.bounds.size
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioPlayer.shared.queue = []
        AudioPlayer.shared.queue = [queueItem(currentStory: content.stories[indexPath.row], currentCollection: content)]
        AudioPlayer.shared.isPlaying = true
    }
    
    // MARK: - Actions
    @objc func setupPlayer() {
        if !AudioPlayer.shared.isPlaying {
            playPauseButton.setTitle("Pause", for: .normal)
        } else {
            if AudioPlayer.shared.queue[0].currentCollection.title == content.title {
                playPauseButton.setTitle("Play", for: .normal)
            } else {
                playPauseButton.setTitle("Play All", for: .normal)
            }
        }
    }
    @IBAction func playButtonPressed(_ sender: UIButton) {
        guard AudioPlayer.shared.queue.count != 0 else {
            AudioPlayer.shared.queue = []
            var index = 0
            for _ in content.stories {
                AudioPlayer.shared.queue.append(queueItem(currentStory: content.stories[index], currentCollection: content))
                index += 1
            }
            AudioPlayer.shared.isPlaying = true
            return
        }
        guard AudioPlayer.shared.queue[0].currentCollection.title == content.title else {
            AudioPlayer.shared.queue = []
            var index = 0
            for _ in content.stories {
                AudioPlayer.shared.queue.append(queueItem(currentStory: content.stories[index], currentCollection: content))
                index += 1
            }
            AudioPlayer.shared.isPlaying = true
            return
        }
        if !AudioPlayer.shared.isPlaying {
            AudioPlayer.shared.isPlaying = true
        } else {
            AudioPlayer.shared.isPlaying = false
        }
    }
    
    @IBAction func creatorPressed(_ sender: UIButton) {
        profileViewer = content.creator
        performSegue(withIdentifier: "toProfile", sender: self)
    }
}
