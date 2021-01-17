//
//  Collection.swift
//  Listnr
//
//  Created by Oliver Moscow on 1/15/21.
//  Copyright © 2021 Listnr. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Structs
struct RecentCollection {
    var rCollection = Collection()
    var isProfile = Bool()
}

struct Collection {
    var stories: [Story] = []
    var title = String()
    var creator = User()
    var coverArt = UIImage()
    var views = Int()
}
