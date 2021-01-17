//
//  HomeTableViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 10/21/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit
// MARK: Variables
//These are global variables
// TODO - Remove this
// calls from randomColorGenerator.swift
let model: [[UIColor]] = generateRandomData()

class HomeTableViewController: UITableViewController {
    
    var homeHeaderTitleArray: [String] = []
    var homeHeaderDescriptionArray: [String] = []
    var homeCollectionViewContentArray: [[Collection]] = []
    
    var cellData: [homePageCellData] = []
    var selectedCollection = Collection()
    
    struct homePageCellData {
        var headerTitle = String()
        var headerDescription = String()
        var collectionViewContent: [[Collection]] = []
    }
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        cellData = []
        setupHomePage()
        // seting up the tabbar so that it can present stuff
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.Name("reload"), object: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCollection" {
            let nvc = segue.destination as! CollectionTableViewController
            nvc.content = selectedCollection
        }
        if segue.identifier == "showProfile" {
            profileUser = selectedCollection.creator
        }
    }
    // MARK: Table View
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
    @objc func reload() {
        cellData = []
        setupHomePage()
        tableView.reloadData()
    }
    @IBAction func refreshing(_ sender: UIRefreshControl) {
        reload()
        sender.endRefreshing()
    }
    
}
// MARK: Collection View
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
        if homeHeaderTitleArray[collectionView.tag] == "Subscribed" {
            cell.coverArt.layer.cornerRadius = cell.coverArt.bounds.width / 2
            cell.coverArt.image = data[indexPath.row].coverArt
            if userData.subscribedUsers[indexPath.item].new == true {
                cell.indicator.isHidden = false
            } else {
                cell.indicator.isHidden = true
            }
            cell.artist.text = ""
            cell.title.textAlignment = .center
            cell.title.text = data[indexPath.row].creator.name
            return cell
        } else if homeHeaderTitleArray[collectionView.tag] == "Categories" {
            cell.coverArt.layer.cornerRadius = 15
            cell.artist.text = ""
            cell.coverArt.image = data[indexPath.row].coverArt
            cell.coverArt.backgroundColor = cell.coverArt.image?.averageColor
            cell.title.text = data[indexPath.row].title
            cell.indicator.isHidden = true
            return cell
        } else if homeHeaderTitleArray[collectionView.tag] == "Recents"{
            cell.coverArt.image = data[indexPath.row].coverArt
            cell.indicator.isHidden = true
            cell.title.text = data[indexPath.row].title
            if userData.recentCollections[indexPath.row].isProfile == true {
                cell.coverArt.layer.cornerRadius = cell.coverArt.bounds.width / 2
                cell.title.textAlignment = .center
                cell.artist.text = ""
            } else {
                cell.coverArt.layer.cornerRadius = 5
                cell.title.textAlignment = .left
                cell.artist.text = data[indexPath.row].creator.name
            }
        } else {
            cell.coverArt.image = nil
            cell.coverArt.backgroundColor = model[indexPath.row][collectionView.tag]
            cell.indicator.isHidden = true
            cell.title.text = ""
            cell.artist.text = ""
            cell.layer.cornerRadius = 5
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCollection = homeCollectionViewContentArray[collectionView.tag][indexPath.row]
        if homeHeaderTitleArray[collectionView.tag] == "Subscribed" {
            performSegue(withIdentifier: "showProfile", sender: self)
        } else if homeHeaderTitleArray[collectionView.tag] == "Recents" {
            if userData.recentCollections[indexPath.row].isProfile == true {
                performSegue(withIdentifier: "showProfile", sender: self)
            } else {
                performSegue(withIdentifier: "toCollection", sender: self)
            }
        } else {
            performSegue(withIdentifier: "toCollection", sender: self)
        }
    }
}
//MARK: - setupHomePage
extension HomeTableViewController {
    func setupHomePage() {
        // seting up sections
        homeHeaderTitleArray = []
        homeHeaderDescriptionArray = []
        homeCollectionViewContentArray = []
        
        if userData.subscribedUsers.count != 0 {
            homeHeaderTitleArray.append("Subscribed")
            homeHeaderDescriptionArray.append("Latest from the people you subscribed to")
        }
        if userData.recentCollections.count != 0 {
            homeHeaderTitleArray.append("Recents")
            homeHeaderDescriptionArray.append("What you looked at recently")
        }
        homeHeaderTitleArray.append("Categories")
        homeHeaderDescriptionArray.append("Categories of stories")
        homeHeaderTitleArray.append("Trending")
        homeHeaderDescriptionArray.append("Todays top stories")
        homeHeaderTitleArray.append("Discover")
        homeHeaderDescriptionArray.append("Find stories from around the world")
//        let content: [String : String] = ["Categories" : "Categories of stories", "Trending" : "Todays top stories", "Discover" : "Find new stories from around the world"]
//        for (key, value) in content {
//            homeHeaderTitleArray.append(key)
//            homeHeaderDescriptionArray.append(value)
//        }
        var sampleIndex = 0
        let sampleSequence = 1...8
        
        for title in homeHeaderTitleArray {
            homeCollectionViewContentArray.insert([], at: sampleIndex)
            var input = homeCollectionViewContentArray[sampleIndex]
            if title == "Categories"  {
                for n in 0 ..< categories.count {
                    input.append(categories[n])
                    homeCollectionViewContentArray.insert(input, at: sampleIndex)
                }
            } else if title == "Subscribed" {
                for n in 0 ..< userData.subscribedUsers.count {
                    input.append(Collection(stories: userData.subscribedUsers[n].sUser.stories, title: userData.subscribedUsers[n].sUser.name, creator: userData.subscribedUsers[n].sUser, coverArt: userData.subscribedUsers[n].sUser.profileImage))
                    homeCollectionViewContentArray.insert(input, at: sampleIndex)
                }
                
            } else if title == "Recents" {
                for n in 0 ..< userData.recentCollections.count {
                    input.append(userData.recentCollections[n].rCollection)
                    homeCollectionViewContentArray.insert(input, at: sampleIndex)
                }
            } else {
                for _ in sampleSequence {
                    input.insert(Collection(stories: [], title: "", creator: User(name: "", username: "", stories: [], collections: [], profileImage: UIImage(named: "noImageIcon")!, subscribers: 0) ,coverArt: UIImage(named: "noImageIcon")!), at: input.endIndex)
                    homeCollectionViewContentArray.insert(input, at: sampleIndex)
                }
            }
            sampleIndex += 1
        }
        var index = 0
        for _ in homeHeaderTitleArray {
            cellData.append(homePageCellData(headerTitle: homeHeaderTitleArray[index], headerDescription: homeHeaderDescriptionArray[index], collectionViewContent: [homeCollectionViewContentArray[index]]))
            index += 1
        }
    }
}
