//
//  SetUpProfilePage.swift
//  Listnr
//
//  Created by Oliver Moscow on 10/23/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import Foundation

func setUpProfilePage() {
    //calls from variable in global variables.swift
    // FIREBASE - update user data with the actual user data from the cloud. Insert it where the quotation marks are.
    userData.name = "Oliver Moscow"
    userData.username = "@The GOAT"
    // user profile image goes here as well
    
    // 
    let sequence = 1...6
    for n in sequence {
    userData.stories.append(story(title: "Title of Story \(n)", creator: "Creator \(n)", coverArt: "testtttt", dateUploaded: 5 + n))
    }
    
    // FIREBASE - this is the code to insert elements into the profile page
    // this is also where to upload audio content after recording
//    userData.stories.append(story(title: "test", creator: "test", coverArt: "test"))
    
}
