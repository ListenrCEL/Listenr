////
////  SetUpFilesPage.swift
////  Listnr
////
////  Created by Oliver Moscow on 10/23/19.
////  Copyright © 2019 Listnr. All rights reserved.
////
//
//import Foundation
////// collection Variables
////var filesCollectionsStoriesArray: [[story]] = []
////var filesCollectionsTitlesArray: [String] = []
//var filesCollectionData: [collection] = []
////
////// subscribed Variables
////var subscribedUserStories: [[story]] = []
////var subscribedUserUsernames: [String] = []
////var subscribedUserNames: [String] = []
////var subscribedCollectionViewData: [story] = []
////
////func setUpFilesPage() {
////    //  SUBSCRIBED
////    //  Change to upload information from firebase
////    //  TODO add this code to the subscribe button.
////    let subscribedSequence = 1...4
////    for n in subscribedSequence{
////        let index = n - 1
////        subscribedUserNames.append("Name \(n)")
////        subscribedUserUsernames.append("Username \(n)")
////        subscribedUserStories.append([])
////        let storySequence = 1...10
////        for item in storySequence {
////            var insert = subscribedUserStories[index]
//////            insert.insert(story(title: "\(subscribedUserNames[index]) \(item)", creator: "\(subscribedUserNames[index]) \(item)", coverArt: "test", dateUploaded: ""), at: insert.startIndex)
//////            subscribedUserStories.insert(insert, at: index)
//////        }
//////    }
//////
//////    var dates: [Int] = []
//////    var indexForUserNames = 0
//////    for _ in subscribedUserNames {
//////        var feed = subscribedUserStories[indexForUserNames]
//////        var feedIndex = 0
//////        for _ in feed {
//////            let insert = feed[feedIndex].dateUploaded
////////            dates.append(insert)
//////            feedIndex += 1
//////        }
//////        indexForUserNames += 1
//////    }
////////
////////    print(dates)
//////
//////    //  SAVED COLLECTIONS
//////    // inserting collection info into arrays
//////    // FIREBASE - this is all test data change to Firebase uploads
//////    let collectionSequence = 1...3
//////    for n in collectionSequence {
//////        let index = n - 1
//////        filesCollectionsTitlesArray.append("Title \(n)")
//////        filesCollectionsStoriesArray.insert([], at: index)
//////
//////        // inserting stories to each collection
//////        let storySequence = 1...6
//////        for item in storySequence {
//////            var insert = filesCollectionsStoriesArray[index]
////////            insert.insert(story(title: "\(filesCollectionsTitlesArray[index]) \(item)", creator: "\(filesCollectionsTitlesArray[index]) \(item)", coverArt: "test", dateUploaded: 5 + item), at: insert.startIndex)
//////            filesCollectionsStoriesArray.insert(insert, at: index)
//////        }
//////    }
//////    var saveIndex = 0
//////    for title in filesCollectionsTitlesArray{
//////        filesCollectionData.append(collection(stories: filesCollectionsStoriesArray[saveIndex], title: title))
//////        saveIndex += 1
//////    }
//////}
////
