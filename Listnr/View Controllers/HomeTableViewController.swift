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
    var homeCollectionViewContentArray: [[collection]] = []
    
    var cellData: [homePageCellData] = []
    var selectedCollection = collection()
    
    struct homePageCellData {
        var headerTitle = String()
        var headerDescription = String()
        var collectionViewContent: [[collection]] = []
    }
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // seting up the tabbar so that it can present stuff
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        // calls from "Global Variables.swift"
        setupHomePage()
        // populates cellData
        var index = 0
        for _ in homeHeaderTitleArray {
            cellData.append(homePageCellData(headerTitle: homeHeaderTitleArray[index], headerDescription: homeHeaderDescriptionArray[index], collectionViewContent: [homeCollectionViewContentArray[index]]))
            index += 1
        }
         NotificationCenter.default.addObserver(self, selector: #selector(viewDidLoad), name: Notification.Name("reloadProfile"), object: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCollection" {
            let nvc = segue.destination as! CollectionTableViewController
            nvc.content = selectedCollection
        }
        if segue.identifier == "showProfile" {
            profileViewer = selectedCollection.creator
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
//            cell.coverArt.image = data[indexPath.row].coverArt
            cell.indicator.isHidden = false
            cell.artist.text = ""
            cell.title.textAlignment = .center
            cell.title.text = data[indexPath.row].creator.name
            return cell
        } else {
//            cell.coverArt.image = data[indexPath.row].coverArt
            cell.indicator.isHidden = true
            cell.title.text = data[indexPath.row].title
            cell.artist.text = data[indexPath.row].creator.name
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCollection = homeCollectionViewContentArray[collectionView.tag][indexPath.row]
        if homeHeaderTitleArray[collectionView.tag] == "Subscribed" {
            performSegue(withIdentifier: "showProfile", sender: self)
        } else {
            performSegue(withIdentifier: "toCollection", sender: self)
        }
    }
}
extension HomeTableViewController {
    
    func setupHomePage() {
        homeHeaderTitleArray.append("Subscribed")
        homeHeaderDescriptionArray.append("Latest from the people you subscribed to")
        homeHeaderTitleArray.append("Recents")
        homeHeaderDescriptionArray.append("Stories you listened to recently")
        homeHeaderTitleArray.append("Discover")
        homeHeaderDescriptionArray.append("Find new stories from around the world")
        homeHeaderTitleArray.append("Trending")
        homeHeaderDescriptionArray.append("Todays top stories")
        var sampleIndex = 0
        let sampleSequence = 1...8
        for _ in homeHeaderTitleArray {
            homeCollectionViewContentArray.insert([], at: sampleIndex)
            var input = homeCollectionViewContentArray[sampleIndex]
            for n in sampleSequence {
                input.insert(collection(stories: [
                    story(title: "OrangeFOOOOOOOT", creator: userData.data, coverArt: UIImage(named: "noImageIcon")!, dateUploaded: "", anonomous: false, storyURl: orangeFoot!),
                    story(title: "Chicken man", creator: userData.data, coverArt: UIImage(named: "Image1")!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: "If_I_Had_a_Chicken", withExtension: "mp3")!),
                    story(title: "MR_TEA", creator: userData.data, coverArt: UIImage(named: "Image2")!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: "Mr_Tea", withExtension: "mp3")!),
                ], title: "Collection \(n)", creator: User(name: "THEo Xiong", username: "@TTTTHHHEEEO", stories: [
                    story(title: "OrangeFOOOOOOOT", creator: userData.data, coverArt: UIImage(named: "noImageIcon")!, dateUploaded: "", anonomous: false, storyURl: orangeFoot!),
                    story(title: "Chicken man", creator: userData.data, coverArt: UIImage(named: "Image1")!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: "If_I_Had_a_Chicken", withExtension: "mp3")!),
                    story(title: "MR_TEA", creator: userData.data, coverArt: UIImage(named: "Image2")!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: "Mr_Tea", withExtension: "mp3")!),
                ], collections: [collection(stories: userData.data.stories, title: "I love eating pizza", creator: userData.data, coverArt: UIImage(named: "Image2")!)], profileImage: UIImage(named: "noImageIcon")!) ,coverArt: UIImage(named: "Image1")!), at: input.endIndex)
                homeCollectionViewContentArray.insert(input, at: sampleIndex)
            }
            sampleIndex += 1
        }
    }
}
