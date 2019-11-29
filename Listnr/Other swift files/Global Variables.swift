//
//  Global Variables.swift
//  Listnr
//
//  Created by Oliver Moscow on 10/22/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import Foundation
import UIKit
// This is most of the global variables but not all of them

struct uploadPkg
{
    let userName: String
    let audioName: String
    let audioFileURL: URL
    let clipArtURL: URL
}

class variables {
    static let shared = variables()
    private init(){}
}
// MARK: Variables
let userData = currentUser()
let orangeFoot = Bundle.main.url(forResource: "orangeFoot", withExtension: "mp3")


// MARK: Structs
struct story {
    var title = String()
    var creator = String()
    var coverArt = UIImage()
    var dateUploaded = String()
    var anonomous = Bool()
    var storyURl = URL(fileURLWithPath:"/path/to/file.ext")
    
//  This needs to be updated as we add more data to each story. The commented out code below are some examples of what should be added later
//    var time = String()
    // var description = String()
    // var tags: [string] = []
    // var videoURl = URL()
}
struct user {
    var name = String()
    var username = String()
    var stories: [story] = []
}
struct collection {
    var stories: [story] = []
    var title = String()
    var creator = String()
}

// MARK: Classes
class currentUser {
    var username = String()
    var name = String()
    var profileImage = String()
    var stories: [story] = []
    var collections: [collection] = []
    var subscribedCreators: [user] = []
    
    // This will also be updated later
    // var savedStories: [[story]] = []
}
