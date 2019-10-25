//
//  FilesTableViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 10/23/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class FilesTableViewController: UITableViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    var filesCollectionData: [collection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFilesPage()
        
        //SUBSCRIBED
        var subscribedIndex = 0
        for _ in subscribedUserNames {
            userData.subscribedCreators.append(user(name: subscribedUserNames[subscribedIndex], username: subscribedUserUsernames[subscribedIndex], stories: subscribedUserStories[subscribedIndex]))
            subscribedIndex += 1
        }
        
        // SAVED COLLECTION
        var saveIndex = 0
        for title in filesCollectionsTitlesArray{
            filesCollectionData.append(collection(stories: filesCollectionsStoriesArray[saveIndex], title: title))
            saveIndex += 1
        } 
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filesCollectionData.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FilesTableViewCell
        cell.backgroundColor = model[4][indexPath.row]
        cell.titleLabel.text = filesCollectionData[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model[1].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilesCollectionViewCell
        cell.backgroundColor = .lightGray
        cell.coverArt.backgroundColor = model[6][indexPath.item]
        
        return cell
    }
}
