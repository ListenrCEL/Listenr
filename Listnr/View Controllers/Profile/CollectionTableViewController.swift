//
//  CollectionTableViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 11/22/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class CollectionTableViewController: UITableViewController {

    @IBOutlet weak var playPauseButton: UIBarButtonItem!
    
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
        cell.coverArt.image = content.stories[indexPath.row].coverArt
        cell.title.text = content.stories[indexPath.row].title
        cell.creator.text = content.stories[indexPath.row].creator
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AudioPlayer.shared.queue = [content.stories[indexPath.row]]
        AudioPlayer.shared.isPlaying = true
    }
    @IBAction func playButtonPressed(_ sender: UIBarButtonItem) {
       
        AudioPlayer.shared.queue = content.stories
        
        if !AudioPlayer.shared.isPlaying {
            AudioPlayer.shared.isPlaying = true
            let pause = UIBarButtonItem(image: UIImage(systemName: "pause.fill"), style: .plain, target: self, action: #selector(playButtonPressed(_:)))
            navigationItem.rightBarButtonItems = [pause]
        } else {
            AudioPlayer.shared.isPlaying = false
            let play = UIBarButtonItem(image: UIImage(systemName: "play.fill"), style: .plain, target: self, action: #selector(playButtonPressed(_:)))
            navigationItem.rightBarButtonItems = [play]
        }
    }
}
