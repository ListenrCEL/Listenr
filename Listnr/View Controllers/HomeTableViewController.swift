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
    var homeCollectionViewContentArray: [[story]] = []
    
    var cellData: [homePageCellData] = []
    
    struct homePageCellData {
        var headerTitle = String()
        var headerDescription = String()
        var collectionViewContent: [[story]] = []
    }
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // seting up the tabbar so that it can present stuff
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        // calls from "Global Variables.swift"
        setUpProfile()
        // populates cellData
        var index = 0
        for _ in homeHeaderTitleArray {
            cellData.append(homePageCellData(headerTitle: homeHeaderTitleArray[index], headerDescription: homeHeaderDescriptionArray[index], collectionViewContent: [homeCollectionViewContentArray[index]]))
            index += 1
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
        cell.title.text = data[indexPath.row].title
        cell.artist.text = data[indexPath.row].creator
        return cell
    }
}
extension HomeTableViewController {

    func setupHomePage() {
        // This is set up so that we can change the catigories on the home page. You need to upload it to the right section. Recents = 0, Discover = 1, Trending = 2...
        homeHeaderTitleArray.append("Recents")
        homeHeaderDescriptionArray.append("Stories you listened to recently")
        homeHeaderTitleArray.append("Discover")
        homeHeaderDescriptionArray.append("Find new stories from around the world")
        homeHeaderTitleArray.append("Trending")
        homeHeaderDescriptionArray.append("Todays top stories")

        
    /*
         FIREBASE - this is where you upload stories for the home page.
         
         To upload from the cloud append using this code:
         let index = 0
         var input = homeCollectionViewContentArray[index]
         input.insert(story(title: "test", creator: "test", coverArt: "test"), at: input.startIndex)
         homeCollectionViewContentArray.insert(input, at: index)
         
         # index is the section you are adding it to. If it is Recents: index = 0, Discover: index = 1, Trending: index = 2, ...
         (I dont know what offSetBy is. Look it up)
         # if you want to insert at the end of the section change startIndex to endIndex
         
         ## This format will change as we add more data for each story so if it doesn't work thats why.
    */
        
    //     TODO - This needs to be replaced with real stories and recordings uploaded from firebase
        // Loads sample data
        var sampleIndex = 0
        let sampleSequence = 1...8
        for title in homeHeaderTitleArray {
            homeCollectionViewContentArray.insert([], at: sampleIndex)
            var input = homeCollectionViewContentArray[sampleIndex]
            for n in sampleSequence {
                input.insert(story(title: "\(title) Title \(n)", creator: "\(title) Creator \(n)", dateUploaded: "", storyURl: orangeFoot!), at: input.endIndex)
                homeCollectionViewContentArray.insert(input, at: sampleIndex)
            }
            sampleIndex += 1
        }
    //    let index = 1
    //    var input = homeCollectionViewContentArray[index]
    //    input.insert(story(title: "tommy", creator: "tommy", coverArt: ""), at: input.startIndex)
    //    homeCollectionViewContentArray.insert(input, at: index)
    }
}
