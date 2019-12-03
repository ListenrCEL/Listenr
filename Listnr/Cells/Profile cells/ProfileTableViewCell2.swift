//
//  ProfileTableViewCell2.swift
//  Listnr
//
//  Created by Oliver Moscow on 11/22/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class ProfileTableViewCell2: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var creator: UILabel!
    @IBOutlet weak var coverArt: UIImageView!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var viewsIcon: UIImageView!
    @IBOutlet weak var viewsStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
