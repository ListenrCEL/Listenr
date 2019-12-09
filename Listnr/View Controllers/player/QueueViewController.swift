//
//  QueueViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 11/26/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class QueueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var collectionTitle: UIButton!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isEditing = true
        setupPlayer()
        NotificationCenter.default.addObserver(self, selector: #selector(setupPlayer), name: Notification.Name("updatingPlayer"), object: nil)
    }
    //MARK: - section
    func numberOfSections(in tableView: UITableView) -> Int {
        guard AudioPlayer.shared.queue.count != 0 else { return 1 }
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.frame = CGRect(x: 5, y: 5, width: 100, height: 25)
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        guard AudioPlayer.shared.queue.count != 0 else { label.text = "Playing"; view.addSubview(label); return view }
        if section == 0 {
            label.text = "Playing"
            view.addSubview(label)
        } else {
            label.text = "Up Next"
            view.addSubview(label)
        }
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if AudioPlayer.shared.queue.count == 0 {
            return 0
        } else {
            return 30
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if AudioPlayer.shared.queue.count == 0 {
                return 0
            } else {
                return 1
            }
        } else {
            return AudioPlayer.shared.queue.count
        }
    }
    // MARK: - cellForRow
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QueueTableViewCell
        if AudioPlayer.shared.queue[indexPath.row].currentStory.anonomous == false {
        cell.coverArt.image = AudioPlayer.shared.queue[indexPath.row].currentStory.coverArt
        cell.title.text = AudioPlayer.shared.queue[indexPath.row].currentStory.title
        cell.creator.text = AudioPlayer.shared.queue[indexPath.row].currentStory.creator.name
        } else {
            cell.coverArt.image = UIImage(named: "Anonymous")
            cell.creator.text = "Anonymous"
            cell.title.text = AudioPlayer.shared.queue[indexPath.row].currentStory.title
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard AudioPlayer.shared.queue.count != 0 else { return 60 }
        if indexPath.section == 0 {
            return 60
        } else {
            if indexPath.row == 0 {
                return 0
            } else {
                return 60
            }
        }
    }
    //MARK: - Edit
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AudioPlayer.shared.queue.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let rowToMove = AudioPlayer.shared.queue[sourceIndexPath.row]
        AudioPlayer.shared.queue.remove(at: sourceIndexPath.row)
        AudioPlayer.shared.queue.insert(rowToMove, at: destinationIndexPath.row)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        } else {
            return true
        }
    }
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
            }
            return NSIndexPath(row: row, section: sourceIndexPath.section) as IndexPath
        }
        return proposedDestinationIndexPath
    }
    //MARK: - actions
    @objc func setupPlayer() {
        if AudioPlayer.shared.queue.count != 0 {
            collectionTitle.setTitle(AudioPlayer.shared.queue.first?.currentCollection.title, for: .normal)
            tableView.reloadData()
            if AudioPlayer.shared.isPlaying {
                playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            } else {
                playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            }
        } else {
            collectionTitle.setTitle("Not Playing", for: .normal)
            tableView.reloadData()
        }
    }
    @IBAction func playTapped(_ sender: Any) {
        guard AudioPlayer.shared.queue.count != 0 else { return }
        if !AudioPlayer.shared.isPlaying {
            AudioPlayer.shared.isPlaying = true
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        } else {
            AudioPlayer.shared.isPlaying = false
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        }
    }
    @IBAction func skipTapped(_ sender: UIButton) {
        AudioPlayer.shared.next()
    }
    @IBAction func backTapped(_ sender: UIButton) {
        AudioPlayer.shared.back()
    }
    @IBAction func forward30(_ sender: UIButton) {
        AudioPlayer.shared.fastForward()
    }
    @IBAction func back30(_ sender: UIButton) {
        AudioPlayer.shared.rewind()
    }
    @IBAction func exit(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
