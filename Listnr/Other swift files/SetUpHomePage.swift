//
//  SetUpHomePage.swift
//  Listnr
//
//  Created by Oliver Moscow on 10/22/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import Foundation
import UIKit

var homeHeaderTitleArray: [String] = []
var homeHeaderDescriptionArray: [String] = []
var homeCollectionViewContentArray: [[story]] = []

func setupHomePage() {
    // This is set up so that we can change the catigories on the home page. You need to upload it to the right section. Recents = 0, Discover = 1, Trending = 2...
    homeHeaderTitleArray.append("Recents")
    homeHeaderDescriptionArray.append("Stories you listened to recently")
    homeHeaderTitleArray.append("Discover")
    homeHeaderDescriptionArray.append("Find new stories from around the world")
    homeHeaderTitleArray.append("Trending")
    homeHeaderDescriptionArray.append("Todays top stories")

    
/*
     FIREBASE - this is where you upload stories for the home page.
     
     To upload from the cloud append using this code:
     let index = 0
     var input = homeCollectionViewContentArray[index]
     input.insert(story(title: "test", creator: "test", coverArt: "test"), at: input.startIndex)
     homeCollectionViewContentArray.insert(input, at: index)
     
     # index is the section you are adding it to. If it is Recents: index = 0, Discover: index = 1, Trending: index = 2, ...
     (I dont know what offSetBy is. Look it up)
     # if you want to insert at the end of the section change startIndex to endIndex
     
     ## This format will change as we add more data for each story so if it doesn't work thats why.
*/
    
//     TODO - This needs to be replaced with real stories and recordings uploaded from firebase
    // Loads sample data
    var sampleIndex = 0
    let sampleSequence = 1...8
    for title in homeHeaderTitleArray {
        homeCollectionViewContentArray.insert([], at: sampleIndex)
        var input = homeCollectionViewContentArray[sampleIndex]
        for n in sampleSequence {
            input.insert(story(title: "\(title) Title \(n)", creator: "\(title) Creator \(n)", dateUploaded: ""), at: input.endIndex)
            homeCollectionViewContentArray.insert(input, at: sampleIndex)
        }
        sampleIndex += 1
    }
//    let index = 1
//    var input = homeCollectionViewContentArray[index]
//    input.insert(story(title: "tommy", creator: "tommy", coverArt: ""), at: input.startIndex)
//    homeCollectionViewContentArray.insert(input, at: index)
}
