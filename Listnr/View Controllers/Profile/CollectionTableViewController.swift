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
        navigationItem.title = content.title
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.stories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CollectionTableViewCell
        cell.imageView?.image = content.stories[indexPath.row].coverArt
        cell.title.text = content.stories[indexPath.row].title
        cell.creator.text = content.stories[indexPath.row].creator
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioPlayer.shared.audioURl = content.stories[indexPath.row].storyURl
        if !AudioPlayer.shared.isPlaying {
            AudioPlayer.shared.isPlaying = true
        } else {
            AudioPlayer.shared.isPlaying = false
        }
    }
}
