//
//  FirebaseFuncs.swift
//  Listnr
//
//  Created by Theodore Yaotian Xiong on 11/25/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import Foundation
import Firebase

func upload(pkg: uploadPkg)
{
    let db = Firestore.firestore()
    let storage = Storage.storage()

    // metadata
    let audioMetadata = StorageMetadata()
    let jpegMetadata = StorageMetadata()
    audioMetadata.contentType = "audio/mpeg"
    jpegMetadata.contentType = "image/jpeg"
    
    // ref and uplaod
    let audioRef = storage.reference().child(pkg.userName + "/stories/" + pkg.audioName + ".m4a")
    let clipRef = storage.reference().child(pkg.userName + "/cliparts/" + pkg.audioName + ".jpg")
    let uploadTask = audioRef.putFile(from: pkg.audioFileURL, metadata: audioMetadata)
    let uploadTask1 = clipRef.putFile(from: pkg.clipArtURL, metadata: jpegMetadata)

    // database
    let docRef = db.collection("users").document(pkg.userName)
    docRef.setData([
        pkg.audioName : 1
    ], merge: true) { err in
        if let err = err {
            print("Error writing document: \(err)")
        } else {
            print("Document successfully written!")
        }
    }


    
    // see if upload be done
    uploadTask.observe(.success) { snapshot in
        print("upload works")
    }
    
    // if upload failed, check wut happened
    /*uploadTask.observe(.failure) { snapshot in
        if let error = snapshot.error as NSError? {
            print("Error uploading")
        }
    }*/
    print(pkg)
}

func uploadAudio()
{
    let imageURL = Bundle.main.url(forResource: "clippp", withExtension: ".jpg")
    let pkg = uploadPkg(userName: userData.data.username, audioName: userData.data.stories.last!.title, audioFileURL: userData.data.stories.last!.storyURl, clipArtURL: imageURL!)
    upload(pkg: pkg)
}

func loadStoriesProfile()
{
    
    
}

