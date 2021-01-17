//
//  Story.swift
//  Listnr
//
//  Created by Oliver Moscow on 1/15/21.
//  Copyright © 2021 Listnr. All rights reserved.
//

import Foundation
import UIKit

struct Story {
    var title = String()
    var creator = User()
    var coverArt = UIImage()
    var dateUploaded = String()
    var anonomous = Bool()
    var storyURl = URL(fileURLWithPath:"/path/to/file.ext")
    var views = Int()
    
}
