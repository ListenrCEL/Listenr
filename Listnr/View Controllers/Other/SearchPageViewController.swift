//
//  SearchPageViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 10/23/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class SearchPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: - Setup
    @IBOutlet weak var tableView: UITableView!
    
    var searchType: [String] = ["Users", "Collections", "Stories"]
    
    var searchUsers: [User] = []
    var searchStories: [Story] = []
    var searchCollections: [Collection] = []
    
    var searchResults : [Any] = []
    
    var recentSearchesUser: [User] = []
    var recentSearchesCollection: [Collection] = []
    var recentSearchesStory: [Story] = []
    
    var recentSearchs : [Any] = []
    
    var searching: Bool = false
    
    var selectedColection = Collection()
//
//    var recentSearches: [recentSearch] = []
//
//    enum recentSearch {
//        case user(User)
//        case collection(collection)
//        case story(story)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchUsers = recentSearchesUser
        searchCollections = recentSearchesCollection
        searchStories = recentSearchesStory
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "User, Collection, or Story"
        search.searchBar.delegate = self
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCollection" {
            let nvc = segue.destination as! CollectionTableViewController
            nvc.content = selectedColection
        }
    }
    //MARK: searchResults
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        guard text != "" else { searching = false; return }
        searching = true
        searchUsers = []
        searchStories = []
        searchCollections = []
        for x in 0 ..< users.count {
            
            var username = users[x].username
            username.remove(at: username.startIndex)
            //            let t = text.range(of: text, options: .caseInsensitive)
            if username.hasPrefix(text) {
                searchUsers.append(users[x])
            } else {
                
                let name = users[x].name
                if name.hasPrefix(text) {
                    searchUsers.append(users[x])
                }
            }
            searchUsers.sort {
                $0.subscribers > $1.subscribers
            }
            for y in 0 ..< users[x].collections.count {
                if users[x].collections[y].title.hasPrefix(text) {
                    searchCollections.append(users[x].collections[y])
                }
                searchCollections.sort {
                    $0.views > $1.views
                }
            }
            for z in 0 ..< users[x].stories.count {
                if users[x].stories[z].title.hasPrefix(text){
                    searchStories.append(users[x].stories[z])
                }
                searchStories.sort {
                    $0.views > $1.views
                }
            }
        }
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchUsers = recentSearchesUser
        searchCollections = recentSearchesCollection
        searchStories = recentSearchesStory
        tableView.reloadData()
    }
    // MARK: - TableView
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if searchUsers.count == 0 {
                return 0
            } else {
                return 35
            }
        } else if section == 1 {
            if searchCollections.count == 0 {
                return 0
            } else {
                return 35
            }
        } else {
            if searchStories.count == 0 {
                return 0
            } else {
                return 35
            }
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        
        view.backgroundColor = .systemBackground
        label.frame = CGRect(x: 5, y: 5, width: 200, height: 30)
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        label.text = searchType[section]
        view.addSubview(label)
        
        return view
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchType[section]
    }
    // MARK: numberOfRows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if searchUsers.count <= 5 {
                return searchUsers.count
            } else {
                return 5
            }
        } else if section == 1 {
            if searchCollections.count <= 5 {
                return searchCollections.count
            } else {
                return 5
            }
        } else {
            if searchStories.count <= 5 {
                return searchStories.count
            } else {
                return 5
            }
        }
    }
    // MARK: cellForRow
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        //        if searching == false {
        //            if indexPath.section == 0 {
        //                if recentSearches[indexPath.row] = .user {
        //
        //                }
        //            }
        //        }
        if searchType[indexPath.section] == "Users" {
//            let user = searchResults[indexPath.row] as! User
            let size = cell.cellImage.bounds.width
            cell.cellImage.layer.cornerRadius = (size)/2
            cell.accessoryType = .disclosureIndicator
            if searching == true {
//                cell.title.text = user.name
                cell.cellImage.image = searchUsers[indexPath.row].profileImage
                cell.title.text = searchUsers[indexPath.row].name
                cell.creatorLabel.text = searchUsers[indexPath.row].username
            } else if searching != true {
                cell.cellImage.image = recentSearchesUser[indexPath.row].profileImage
                cell.title.text = recentSearchesUser[indexPath.row].name
                cell.creatorLabel.text = recentSearchesUser[indexPath.row].username
            }
            return cell
        } else if searchType[indexPath.section] == "Collections" {
            cell.cellImage.layer.cornerRadius = 0
            cell.accessoryType = .disclosureIndicator
            if searching == true {
                cell.cellImage.image = searchCollections[indexPath.row].coverArt
                cell.title.text = searchCollections[indexPath.row].title
                cell.creatorLabel.text = searchCollections[indexPath.row].creator.name
            } else {
                cell.cellImage.image = recentSearchesCollection[indexPath.row].coverArt
                cell.title.text = recentSearchesCollection[indexPath.row].title
                cell.title.text = recentSearchesCollection[indexPath.row].creator.name
            }
            return cell
        } else {
            cell.cellImage.layer.cornerRadius = 5
            cell.accessoryType = .none
            if searching == true {
                cell.cellImage.image = searchStories[indexPath.row].coverArt
                cell.title.text = searchStories[indexPath.row].title
                cell.creatorLabel.text = searchStories[indexPath.row].creator.name
            } else {
                cell.cellImage.image = recentSearchesStory[indexPath.row].coverArt
                cell.title.text = recentSearchesStory[indexPath.row].title
                cell.creatorLabel.text = recentSearchesStory[indexPath.row].creator.name
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if searching == true {
                recentSearchesUser.append(searchUsers[indexPath.row])
                //                recentSearches.append(.user(searchUsers[indexPath.row]))
            }
            profileUser = searchUsers[indexPath.row]
            performSegue(withIdentifier: "toProfile", sender: self)
        } else if indexPath.section == 1 {
            if searching == true {
                recentSearchesCollection.append(searchCollections[indexPath.row])
            }
            selectedColection = searchCollections[indexPath.row]
            performSegue(withIdentifier: "toCollection", sender: self)
        } else {
            if searching == true {
                recentSearchesStory.append(searchStories[indexPath.row])
            }
            selectedCellDetailQueue = []
            selectedCellDetailQueue.append(queueItem(currentStory: searchStories[indexPath.row], currentCollection: Collection(stories: [], title: "", creator: userData.data, coverArt: UIImage(named: "image3")!)))
            selectedCellDetailStory = searchStories[indexPath.row]
            NotificationCenter.default.post(name: Notification.Name("presentSelectedCellDetail"), object: nil)
        }
    }
}




