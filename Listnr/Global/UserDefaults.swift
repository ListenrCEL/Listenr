//
//  UserDefaults.swift
//  Listnr
//
//  Created by Oliver Moscow on 1/15/21.
//  Copyright © 2021 Listnr. All rights reserved.
//

import Foundation

func setupAcount(user: User) {
    let defaults = UserDefaults.standard
    defaults.set(user.age, forKey: "Age")
    defaults.set(user.name, forKey: "Name")
    defaults.set(user.username, forKey: "Username")
    defaults.set(user.age, forKey: "Age")
    
    let image = user.profileImage.pngData()
    defaults.set(image, forKey: "ProfileImage")
    
    //recover image: UserDefaults.standard.object(forKey: "ProfileImage") as! Data
    
}
