//
//  SearchPageViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 10/23/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class SearchPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var searchType: [String] = []
    var searchContent: [story] = []
    let color: [[UIColor]] = generateRandomData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sequence = 1...6
        for n in sequence {
            if n % 3 == 2{
                searchType.append("Story")
                searchContent.append(story(title: "Title \(n)", creator: "creator \(n)"))
            } else {
                searchType.append("Artist")
                searchContent.append(story(title: "Title \(n)", creator: "Name"))
                
            }
        }
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        if searchType[indexPath.row] == "Artist" {
            let size = cell.cellImage.bounds.width
            cell.cellImage.layer.cornerRadius = (size)/2
            cell.cellImage.layer.masksToBounds = true
        }
        cell.accessoryType = .disclosureIndicator
        cell.cellImage.backgroundColor = color[0][indexPath.row]
        cell.titleLabel.text = searchContent[indexPath.row].title
        return cell
    }
}
