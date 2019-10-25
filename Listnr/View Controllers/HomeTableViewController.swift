//
//  HomeTableViewController.swift
//  Listenr
//
//  Created by Oliver Moscow on 10/21/19.
//  Copyright © 2019 Listenr. All rights reserved.
//

import UIKit
//These are global variables
// TODO - Remove this
// calls from randomColorGenerator.swift
let model: [[UIColor]] = generateRandomData()

// Home Table view set up
class HomeTableViewController: UITableViewController {
    
    var cellData: [homePageCellData] = []
    
    struct homePageCellData {
        var headerTitle = String()
        var headerDescription = String()
        var collectionViewContent: [[story]] = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // calls from "Global Variables.swift"
        setupHomePage()
        
        // populates cellData
        var index = 0
        for _ in homeHeaderTitleArray {
            cellData.append(homePageCellData(headerTitle: homeHeaderTitleArray[index], headerDescription: homeHeaderDescriptionArray[index], collectionViewContent: [homeCollectionViewContentArray[index]]))
            index += 1
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HomeTableViewCell
        cell.headerTitle.text = cellData[indexPath.row].headerTitle
        cell.headerDescription.text = cellData[indexPath.row].headerDescription
        return cell
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           guard let tableViewCell = cell as? HomeTableViewCell else { return }

           tableViewCell.setCollectionViewDataSourceDelegate( dataSourceDelegate: self, forRow: indexPath.row)
    }
    
}
// Collection view set up
extension HomeTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
        return cellData[collectionView.tag].collectionViewContent.joined().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = cellData[collectionView.tag].collectionViewContent.flatMap { $0 }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath as IndexPath) as! HomeCollectionViewCell
        cell.coverArt.backgroundColor = model[collectionView.tag][indexPath.item]
        cell.title.text = data[indexPath.row].title
        cell.artist.text = data[indexPath.row].creator
        return cell
    }
}
