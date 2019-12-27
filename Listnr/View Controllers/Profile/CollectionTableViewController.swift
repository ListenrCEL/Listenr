//
//  CollectionTableViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 11/22/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit
import AVFoundation

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
        if userData.recentCollections.count == 0 {
            userData.recentCollections.insert(insert, at:  0)
        } else {
            for n in 0 ..< userData.recentCollections.count {
                if userData.recentCollections[n].rCollection.title == content.title && userData.recentCollections[n].rCollection.creator.username == content.creator.username{
                    userData.recentCollections.remove(at: n)
                    break
                }
            }
            userData.recentCollections.insert(insert, at:  0)
        }
        guard let color = content.coverArt.averageColor else { return }
        if (color.isLight())! {
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
        cell.imageView?.bounds.size = cell.bounds.size
        if content.stories[indexPath.row].anonomous == true {
            cell.creator.text = "Anonymous"
            cell.title.text = content.stories[indexPath.row].title
            cell.coverArt.image = UIImage(named: "Anonymous")
        } else {
            cell.coverArt.image = content.stories[indexPath.row].coverArt
            cell.title.text = content.stories[indexPath.row].title
            cell.creator.text = content.stories[indexPath.row].creator.name
        }
        let asset = AVURLAsset.init(url: content.stories[indexPath.row].storyURl.absoluteURL, options: nil)
        let audioDuration = CMTimeGetSeconds(asset.duration)
        if audioDuration <= 1000 {
            cell.timeLabel.text = String(format: "%2d:%02d", ((Int)((audioDuration))) / 60, ((Int)((audioDuration))) % 60)
        } else {
            cell.timeLabel.text = String(format: "%02d:%02d", ((Int)((audioDuration))) / 60, ((Int)((audioDuration))) % 60)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellDetailQueue = []
        for n in indexPath.row ..< content.stories.count {
            selectedCellDetailQueue.append(queueItem(currentStory: content.stories[n], currentCollection: content))
        }
        selectedCellDetailStory = content.stories[indexPath.row]
        NotificationCenter.default.post(name: Notification.Name("presentSelectedCellDetail"), object: nil)
    }
    
    // MARK: - Actions
    @objc func setupPlayer() {
        if playPauseButton.titleLabel?.text == "Play All" {
            playPauseButton.setTitle("Stop", for: .normal)
        }
    }
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if sender.titleLabel?.text == "Play All" {
            AudioPlayer.shared.isPlaying = false
            AudioPlayer.shared.audioPlayer?.stop()
            AudioPlayer.shared.queue = []
            var index = 0
            for _ in content.stories {
                AudioPlayer.shared.queue.append(queueItem(currentStory: content.stories[index], currentCollection: content))
                index += 1
            }
            AudioPlayer.shared.isPlaying = true
            sender.setTitle("Stop", for: .normal)
        } else if sender.titleLabel?.text == "Stop" {
            AudioPlayer.shared.isPlaying = false
            sender.setTitle("Play All", for: .normal)
        }
    }
    
    @IBAction func creatorPressed(_ sender: UIButton) {
        profileUser = content.creator
        performSegue(withIdentifier: "toProfile", sender: self)
    }
}
