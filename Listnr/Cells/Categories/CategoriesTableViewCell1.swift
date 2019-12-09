//
//  CategoriesTableViewCell1.swift
//  Listnr
//
//  Created by Oliver Moscow on 12/4/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class CategoriesTableViewCell1: UITableViewCell {

    @IBOutlet weak var coverArt: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var bio: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
