//
//  ProfileTableViewCell2.swift
//  Listnr
//
//  Created by Oliver Moscow on 11/22/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class ProfileTableViewCell2: UITableViewCell {

    @IBOutlet weak var cellBackground: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var creator: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
