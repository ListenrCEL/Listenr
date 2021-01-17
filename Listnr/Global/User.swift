//
//  User.swift
//  Listnr
//
//  Created by Oliver Moscow on 1/15/21.
//  Copyright © 2021 Listnr. All rights reserved.
//

import Foundation
import UIKit


struct User {
    var name = String()
    var age = Int()
    var username = String()
    var stories: [Story] = []
    var collections: [Collection] = []
    var profileImage = UIImage()
    var subscribers = Int()
}

struct SubscribedUser {
    var sUser = User()
    var new = Bool()
}
