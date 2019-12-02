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
// MARK: - Variables
var userData = currentUser()
let orangeFoot = Bundle.main.url(forResource: "orangeFoot", withExtension: "mp3")
var categories: [collection] = []
var users: [User] = []


// MARK: - Structs
struct subscribedUser {
    var sUser = User()
    var new = Bool()
}
struct recentCollection {
    var rCollection = collection()
    var isProfile = Bool()
}
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

// MARK: - Classes
class currentUser {
    var data: User = User(name: "Oliver Moscow", username: "@OLLLIIIEEE", stories: [], collections: [], profileImage: UIImage(named: "Image1")!)
    var subscribedUsers: [subscribedUser] = []
    var recentCollections: [recentCollection] = []
}

func setUpProfile() {
    // TEST - Setting up UserData
    userData.data.stories = [
        story(title: "OrangeFOOOOOOOT", creator: userData.data, coverArt: UIImage(named: "noImageIcon")!, dateUploaded: "", anonomous: false, storyURl: orangeFoot!),
        story(title: "Chicken man", creator: userData.data, coverArt: UIImage(named: "Image1")!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: "If_I_Had_a_Chicken", withExtension: "mp3")!),
        story(title: "MR_TEA", creator: userData.data, coverArt: UIImage(named: "Image2")!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: "Mr_Tea", withExtension: "mp3")!),
    ]
    userData.data.collections = [
        collection(stories: userData.data.stories, title: "I love eating pizza", creator: userData.data, coverArt: UIImage(named: "Image2")!)
    ]
    // Firebase
    loadStoriesProfile()
    // Setting up categories
    let catigoriesTitlesArray: [String] = ["Comedy","Sports","Growing up","Voices of SCH","Advice","Motivation","Pride","Romantic","Nature","Family","Injury"]
    var index = 0
    for title in catigoriesTitlesArray {
        categories.append(collection(stories: userData.data.stories, title: title, creator: userData.data, coverArt: UIImage(named: catigoriesTitlesArray[index])!))
        index += 1
    }
    for n in 0 ..< users.count {
        userData.subscribedUsers.append(subscribedUser(sUser: users[n], new: true))
    }
    
    //Making sure there are no more then 15 recents
    var recents: [recentCollection] = []
    for n in 0 ..< userData.recentCollections.count {
        if n > 16 {
            recents.append(userData.recentCollections[n])
        }
    }
    userData.recentCollections = recents
}
// MARK: - TestUsers
func setupTestUsers() {
    // Theo
    var theo = User(name: "THEo Xiong", username: "@TTTTHHHEEEO", stories:
        [], collections: [], profileImage: UIImage(named: "noImageIcon")!)
    var titles = ["Big man Theo", "How to wrestle a gurilla", "Being a coding god"]
    let images = [ "Image1", "Growing up", "Image2"]
    let songs = ["orangeFoot", "If_I_Had_a_Chicken","Mr_Tea"]
    var index = 0
    for title in titles {
        theo.stories.append(story(title: title, creator: theo, coverArt: UIImage(named: images[index])!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: songs[index], withExtension: "mp3")!))
        index += 1
    }
    theo.collections.append(collection(stories: theo.stories, title: "My expert violin training", creator: theo, coverArt: UIImage(named: "Image2")!))
    // David
    var david = User(name: "DAvee LubeLL", username: "@Lil d (David)", stories:
        [], collections: [], profileImage: UIImage(named: "Growing up")!)
    index = 0
    titles = ["Man i love oreos", "Tennis Tennis tennis", "Why wont my mustache grow"]
    for title in titles {
        david.stories.append(story(title: title, creator: david, coverArt: UIImage(named: images[index])!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: songs[index], withExtension: "mp3")!))
        index += 1
    }
    david.collections.append(collection(stories: david.stories, title: "How to make an app logo", creator: theo, coverArt: UIImage(named: "noImageIcon")!))
    users = [theo, david]
}

