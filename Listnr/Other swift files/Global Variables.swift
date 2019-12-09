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
    var views = Int()
    
}
struct User {
    var name = String()
    var username = String()
    var stories: [story] = []
    var collections: [collection] = []
    var profileImage = UIImage()
    var subscribers = Int()
}
struct collection {
    var stories: [story] = []
    var title = String()
    var creator = User()
    var coverArt = UIImage()
    var views = Int()
}

// MARK: - Classes
class currentUser {
    var data: User = User(name: "OLiver Russia", username: "@The GOAT", stories: [], collections: [], profileImage: UIImage(named: "Image1")!, subscribers: 666)
    var subscribedUsers: [subscribedUser] = []
    var recentCollections: [recentCollection] = []
}


//MARK: - Extensions
extension UserDefaults {
    open func setStruct<T: Codable>(_ value: T?, forKey defaultName: String){
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: defaultName)
    }
    
    open func structData<T>(_ type: T.Type, forKey defaultName: String) -> T? where T : Decodable {
        guard let encodedData = data(forKey: defaultName) else {
            return nil
        }
        
        return try! JSONDecoder().decode(type, from: encodedData)
    }
    
    open func setStructArray<T: Codable>(_ value: [T], forKey defaultName: String){
        let data = value.map { try? JSONEncoder().encode($0) }
        
        set(data, forKey: defaultName)
    }
    
    open func structArrayData<T>(_ type: T.Type, forKey defaultName: String) -> [T] where T : Decodable {
        guard let encodedData = array(forKey: defaultName) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
}



//MARK: - TestData
func setUpProfile() {
    // TEST - Setting up UserData
    userData.data.stories = [
        story(title: "OrangeFOOOOOOOT", creator: userData.data, coverArt: UIImage(named: "noImageIcon")!, dateUploaded: "", anonomous: true, storyURl: orangeFoot!, views: 300),
        story(title: "Chicken man", creator: userData.data, coverArt: UIImage(named: "Image1")!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: "If_I_Had_a_Chicken", withExtension: "mp3")!, views: 40),
        story(title: "MR_TEA", creator: userData.data, coverArt: UIImage(named: "Image2")!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: "Mr_Tea", withExtension: "mp3")!, views: 77),
    ]
    userData.data.collections = [
        collection(stories: userData.data.stories, title: "I love eating pizza", creator: userData.data, coverArt: UIImage(named: "Image2")!, views: 876)
    ]
    // Firebase
    loadStoriesProfile()
    // Setting up categories
    let catigoriesTitlesArray: [String] = ["Comedy","Sports","Growing up","Advice","Motivation","Pride","Nature","Injury"]
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
//    setUpProfile()
    // Theo
    var theo = User(name: "THEo Xiong", username: "@TTTTHHHEEEO", stories:
        [], collections: [], profileImage: UIImage(named: "noImageIcon")!, subscribers: 420)
    var titles = ["Big man Theo", "How to wrestle a gurilla", "Being a coding god"]
    let images = [ "Image1", "Growing up", "Image2"]
    let songs = ["orangeFoot", "If_I_Had_a_Chicken","Mr_Tea"]
    var index = 0
    for title in titles {
        theo.stories.append(story(title: title, creator: theo, coverArt: UIImage(named: images[index])!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: songs[index], withExtension: "mp3")!, views: 72))
        index += 1
    }
    theo.stories.append(story(title: "Test", creator: theo, coverArt: UIImage(named: images[1])!, dateUploaded: "", anonomous: true, storyURl: Bundle.main.url(forResource: songs[1], withExtension: "mp3")!, views: 72))
    theo.collections.append(collection(stories: theo.stories, title: "My expert violin training", creator: theo, coverArt: UIImage(named: "Image2")!))
    // David
    var david = User(name: "DAvee LubeLL", username: "@Lil d (David)", stories:
        [], collections: [], profileImage: UIImage(named: "Growing up")!, subscribers: 69)
    index = 0
    titles = ["Man i love oreos", "Tennis Tennis tennis", "Davy boi"]
    for title in titles {
        david.stories.append(story(title: title, creator: david, coverArt: UIImage(named: images[index])!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: songs[index], withExtension: "mp3")!, views: 17))
        index += 1
    }
    david.collections.append(collection(stories: david.stories, title: "How to make an app logo", creator: theo, coverArt: UIImage(named: "noImageIcon")!))
    users = [theo, david, userData.data]
    print(userData.data.stories)
}

