//
//  Global Variables.swift
//  Listnr
//
//  Created by Oliver Moscow on 10/22/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import Foundation
import Firebase
import UIKit
// This is most of the global variables but not all of them

class variables {
    static let shared = variables()
    private init(){}
}
// MARK: - Variables
var userData = currentUser()
let orangeFoot = Bundle.main.url(forResource: "orangeFoot", withExtension: "mp3")
var categories: [Collection] = []
var users: [User] = []




// MARK: - Classes
class currentUser {
    var data: User = User(name: "Demo User", username: "@Demo", stories: [], collections: [], profileImage: UIImage(named: "Image1")!, subscribers: 666)
    var subscribedUsers: [SubscribedUser] = []
    var recentCollections: [RecentCollection] = []
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
func setUpDemoMode() {
    setupTestUsers()
    // TEST - Setting up UserData
    userData.data.stories = [
        Story(title: "test story", creator: userData.data, coverArt: UIImage(named: "image3")!, dateUploaded: "", anonomous: true, storyURl: orangeFoot!, views: 300),
        Story(title: "test story", creator: userData.data, coverArt: UIImage(named: "Image1")!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: "If_I_Had_a_Chicken", withExtension: "mp3")!, views: 40),
        Story(title: "test story", creator: userData.data, coverArt: UIImage(named: "Image2")!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: "Mr_Tea", withExtension: "mp3")!, views: 77),
    ]
    let db = Firestore.firestore()
    let docRef = db.collection("users").document(userData.data.username)
    
    /* docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            let dataDescription = document.data()!
            let storyDict = NSMutableDictionary(dictionary: dataDescription)
            let allStories = storyDict.allKeys
            print("Stories: \(allStories)")
            for i in 0..<allStories.count
            {
                userData.data.stories.append(story(title: allStories[i] as! String, creator: userData.data, coverArt: UIImage(named: "image3")!, dateUploaded: "", anonomous: false, storyURl: orangeFoot!, views: 69))
            }
        } else {
            print("Document does not exist")
        }
    }*/
    userData.data.collections = [
        Collection(stories: userData.data.stories, title: "I love eating pizza", creator: userData.data, coverArt: UIImage(named: "Image2")!, views: 876)
    ]
    // Firebase
    loadStoriesProfile()
    
    //Listenr
    var listenr = User(name: "Listenr", username: "@Listenr", stories:
    [], collections: [], profileImage: UIImage(named: "noImageIcon")!, subscribers: 0)
    
    // Setting up categories
    let catigoriesTitlesArray: [String] = ["Comedy","Growing up","Advice","Motivation","Pride","Nature","Injury"]
    var index = 0
    for title in catigoriesTitlesArray {
        categories.append(Collection(stories: [
            Story(title: "test story", creator: listenr, coverArt: UIImage(named: "image3")!, dateUploaded: "", anonomous: true, storyURl: orangeFoot!, views: 300),
            Story(title: "test story", creator: listenr, coverArt: UIImage(named: "Image1")!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: "If_I_Had_a_Chicken", withExtension: "mp3")!, views: 40),
            Story(title: "test story", creator: listenr, coverArt: UIImage(named: "Image2")!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: "Mr_Tea", withExtension: "mp3")!, views: 77),
        ], title: title, creator: listenr, coverArt: UIImage(named: catigoriesTitlesArray[index])!))
        index += 1
    }
    for n in 0 ..< users.count {
        userData.subscribedUsers.append(SubscribedUser(sUser: users[n], new: true))
    }
    // listnr
    listenr.collections = categories
    users.append(listenr)
    
    //Making sure there are no more then 15 recents
    var recents: [RecentCollection] = []
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
        [], collections: [], profileImage: UIImage(named: "image3")!, subscribers: 420)
    var titles = ["Big man Theo", "How to wrestle a gurilla", "Being a coding god"]
    let images = [ "Image1", "Growing up", "Image2"]
    let songs = ["orangeFoot", "If_I_Had_a_Chicken","Mr_Tea"]
    var index = 0
    for title in titles {
        theo.stories.append(Story(title: title, creator: theo, coverArt: UIImage(named: images[index])!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: songs[index], withExtension: "mp3")!, views: 72))
        index += 1
    }
    theo.stories.append(Story(title: "Test", creator: theo, coverArt: UIImage(named: images[1])!, dateUploaded: "", anonomous: true, storyURl: Bundle.main.url(forResource: songs[1], withExtension: "mp3")!, views: 72))
    theo.collections.append(Collection(stories: theo.stories, title: "My expert violin training", creator: theo, coverArt: UIImage(named: "Image2")!))
    
    // David
    var david = User(name: "DAvee LubeLL", username: "@Lil d (David)", stories:
        [], collections: [], profileImage: UIImage(named: "Growing up")!, subscribers: 69)
    index = 0
    titles = ["Man i love oreos", "Tennis Tennis tennis", "Davy boi"]
    for title in titles {
        david.stories.append(Story(title: title, creator: david, coverArt: UIImage(named: images[index])!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: songs[index], withExtension: "mp3")!, views: 17))
        index += 1
    }
    david.collections.append(Collection(stories: david.stories, title: "How to make an app logo", creator: theo, coverArt: UIImage(named: "image3")!))
    
    // Oliver Russia
    var oliver = User(name: "Oliver Russia", username: "@Violin Man", stories:
        [], collections: [], profileImage: UIImage(named: "Image1")!, subscribers: 69)
    index = 0
    titles = ["Man i love russia", "Wow what an awesome app", "I've actually never been to russia 😬"]
    for title in titles {
        oliver.stories.append(Story(title: title, creator: oliver, coverArt: UIImage(named: images[index])!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: songs[index], withExtension: "mp3")!, views: 17))
        index += 1
    }
    oliver.collections.append(Collection(stories: oliver.stories, title: "Small Boi Chronicles", creator: oliver, coverArt: UIImage(named: "image3")!))
    
    // Jimmy
    var jimmy = User(name: "Jimmy John", username: "@Jimmmmmmy", stories:
        [], collections: [], profileImage: UIImage(named: "jimmy photo")!, subscribers: 69)
    index = 0
    titles = ["Pizza time", "whats a flingo", "happy sunday!!!"]
    for title in titles {
        jimmy.stories.append(Story(title: title, creator: jimmy, coverArt: UIImage(named: images[index])!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: songs[index], withExtension: "mp3")!, views: 17))
        index += 1
    }
    jimmy.collections.append(Collection(stories: jimmy.stories, title: "jimmys life", creator: jimmy, coverArt: UIImage(named: "image3")!))
    
    // Edgar
    var edgar = User(name: "Edgar Morse", username: "@Eddy", stories:
        [], collections: [], profileImage: UIImage(named: "Edgar Morse")!, subscribers: 69)
    index = 0
    titles = ["Pizza time", "whats a flingo", "happy sunday!!!"]
    for title in titles {
        edgar.stories.append(Story(title: title, creator: edgar, coverArt: UIImage(named: images[index])!, dateUploaded: "", anonomous: false, storyURl: Bundle.main.url(forResource: songs[index], withExtension: "mp3")!, views: 17))
        index += 1
    }
    edgar.collections.append(Collection(stories: jimmy.stories, title: "edgar's life", creator: edgar, coverArt: UIImage(named: "image3")!))
    
    users = [theo, david, oliver, jimmy, edgar]
}

