//
//  CategoriesTableViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 12/4/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {

    var content = collection()
    
    @IBOutlet weak var coverArt: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var categoryTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
