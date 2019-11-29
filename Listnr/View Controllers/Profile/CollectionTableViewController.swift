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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let play = UIBarButtonItem(image: UIImage(systemName: "play.fill"), style: .plain, target: self, action: #selector(playButtonPressed(_:)))
        navigationItem.rightBarButtonItems = [play]
        navigationItem.title = content.title
        navigationController?.isNavigationBarHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(setupPlayer), name: Notification.Name("updatingPlayer"), object: nil)
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.stories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CollectionTableViewCell
        cell.coverArt.image = content.stories[indexPath.row].coverArt
        cell.title.text = content.stories[indexPath.row].title
        cell.creator.text = content.stories[indexPath.row].creator
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioPlayer.shared.queue = []
        AudioPlayer.shared.queue = [queueItem(currentStory: content.stories[indexPath.row], currentCollection: content)]
        AudioPlayer.shared.isPlaying = true
    }
    @objc func setupPlayer() {
        if !AudioPlayer.shared.isPlaying {
            let play = UIBarButtonItem(image: UIImage(systemName: "pause.fill"), style: .plain, target: self, action: #selector(playButtonPressed(_:)))
            navigationItem.rightBarButtonItems = [play]
        } else {
            let play = UIBarButtonItem(image: UIImage(systemName: "play.fill"), style: .plain, target: self, action: #selector(playButtonPressed(_:)))
            navigationItem.rightBarButtonItems = [play]
        }
    }
    @objc func playButtonPressed(_ sender: UIBarButtonItem) {
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
    
}
