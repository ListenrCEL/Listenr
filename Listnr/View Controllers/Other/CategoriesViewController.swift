//
//  CategoriesViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 12/4/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var botomView: UIView!
    
    var content = Collection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        content = userData.data.collections[0]
        for n in 0 ..< userData.data.stories.count {
            content.stories.append(userData.data.stories[n])
        }
        for n in 0 ..< userData.data.stories.count {
            content.stories.append(userData.data.stories[n])
        }
        for n in 0 ..< userData.data.stories.count {
            content.stories.append(userData.data.stories[n])
        }
        for n in 0 ..< userData.data.stories.count {
            content.stories.append(userData.data.stories[n])
        }
        for n in 0 ..< userData.data.stories.count {
            content.stories.append(userData.data.stories[n])
        }
        
        navigationController?.isNavigationBarHidden = true
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        guard content.stories.count != 0 else { return 1 }
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return content.stories.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoriesTableViewCell1
            cell.coverArt.image = content.stories[indexPath.row].coverArt
            cell.title.text = content.stories[indexPath.row].title
            cell.creator.text = content.stories[indexPath.row].creator.name
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoriesTableViewCell2
            cell.coverArt.image = content.stories[indexPath.row].coverArt
            cell.title.text = content.stories[indexPath.row].title
            cell.creator.text = content.stories[indexPath.row].creator.name
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 200
        } else {
            if indexPath.row == 0 {
                return 0
            } else {
                return 65
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y / 100
        if offset > 1 {
            navigationController?.setNavigationBarHidden(false, animated: false)
        } else {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
//        let verticalScrollDistance = scrollView.contentOffset.y
//        let bottomOfView = view.frame.height
//
//        botomView.stretchBy(verticalScrollDistance, bottomBound: bottomOfView)
    }
}
