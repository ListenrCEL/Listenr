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
var userData = currentUser()
let orangeFoot = Bundle.main.url(forResource: "orangeFoot", withExtension: "mp3")
var categories: [collection] = []


// MARK: Structs
struct story {
    var title = String()
    var creator = User()
    var coverArt = UIImage()
    var dateUploaded = String()
    var anonomous = Bool()
    var storyURl = URL(fileURLWithPath:"/path/to/file.ext")
    
}
struct User {
    var name = String()
    var username = String()
    var stories: [story] = []
    var collections: [collection] = []
    var profileImage = UIImage()
}
struct collection {
    var stories: [story] = []
    var title = String()
    var creator = User()
    var coverArt = UIImage()
}
struct category {
    var title = String()
    var stories: [story] = []
    var image = UIImage()
}

// MARK: Classes
class currentUser {
    var data: User = User(name: "Oliver Moscow", username: "@OLLLIIIEEE", stories: [], collections: [], profileImage: UIImage(named: "Image1")!)
}

func setUpProfile() {
    userData.data.stories = [
        story(title: "OrangeFOOOOOOOT", creator: userData.data, coverArt: UIImage(named: "noImageIcon")!, dateUploaded: "", anonomous: false, storyURl: orangeFoot!),
        story(title: "Chicken man", creator: userData.data, coverArt: UIImage(named: "Image1")!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: "If_I_Had_a_Chicken", withExtension: "mp3")!),
        story(title: "MR_TEA", creator: userData.data, coverArt: UIImage(named: "Image2")!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: "Mr_Tea", withExtension: "mp3")!),
    ]
    userData.data.collections = [
        collection(stories: userData.data.stories, title: "I love eating pizza", creator: userData.data, coverArt: UIImage(named: "Image2")!)
    ]
    loadStoriesProfile()
   let catigoriesTitlesArray: [String] = ["Comedy","Sports","Growing up","Voices of SCH","Advice","Motivation","Theater","Romantic","Family","Injury"]
    for title in catigoriesTitlesArray {
        categories.append(collection(stories: userData.data.stories, title: title, creator: userData.data, coverArt: UIImage(named: "Image2")!))
    }
    
}
