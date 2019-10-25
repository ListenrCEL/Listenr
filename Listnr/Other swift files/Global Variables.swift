//
//  Global Variables.swift
//  Listenr
//
//  Created by Oliver Moscow on 10/22/19.
//  Copyright © 2019 Listenr. All rights reserved.
//

import Foundation
// This is most of the global variables but not all of them

//Variables
let userData = currentUser()

// Structs
struct story {
    var title = String()
    var creator = String()
    var coverArt = String()
    
//  This needs to be updated as we add more data to each story. The commented out code below are some examples of what should be added later
    
    // var description = String()
    // var tags: [string] = []
    // var time = String()
    // var videoURl = URL()
}
class currentUser {
    var username = String()
    var name = String()
    var profileImage = String()
    var stories: [story] = []
    var subscribedCreators: [user] = []
    
    // This will also be updated later
    // var savedStories: [[story]] = []
}
struct user {
    var name = String()
    var username = String()
    var stories: [story] = []
}
struct collection {
    var stories: [story] = []
    var title = String()
}
