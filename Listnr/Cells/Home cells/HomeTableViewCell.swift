//
//  HomeTableViewCell.swift
//  Listnr
//
//  Created by Oliver Moscow on 10/21/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {


    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var headerDescription: UILabel!
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
