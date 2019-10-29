//
//  FilesTableViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 10/23/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class FilesTableViewController: UITableViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpFilesPage()
    }
    
    // set up table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filesCollectionData.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FilesTableViewCell
        cell.backgroundColor = model[4][indexPath.row]
        cell.titleLabel.text = filesCollectionData[indexPath.row].title
        return cell
    }
    
    // Set up collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model[1].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilesCollectionViewCell
        cell.backgroundColor = .lightGray
        cell.coverArt.backgroundColor = model[6][indexPath.item]
        //jhjhjhlj
        return cell
    }
}
