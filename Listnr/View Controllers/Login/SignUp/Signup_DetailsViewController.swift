//
//  Signup_DetailsViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 12/9/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit
import Firebase

class Signup_DetailsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextFeild: UITextField!
    @IBOutlet weak var usernameTextFeild: UITextField!
    
    var email = String()
    var password = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextFeild.delegate = self
        usernameTextFeild.delegate = self
        if setupData.username != "" {
            usernameTextFeild.text = setupData.username
        }
        if setupData.name != "" {
            nameTextFeild.text = setupData.name
        }
        
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next" {
            setupData.name = nameTextFeild.text!
            setupData.username = "@\(usernameTextFeild.text!)"
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func varify(completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let collectionRef = db.collection("users")
        collectionRef.whereField("username", isEqualTo: "@\(usernameTextFeild.text!)").getDocuments { (snapshot, err) in
                if let err = err {
                    print("Error getting document: \(err)")
                } else if (snapshot?.isEmpty)! {
                    if let currentUser = Auth.auth().currentUser?.createProfileChangeRequest() {
                        currentUser.displayName = "@\(self.usernameTextFeild.text!)"
                        currentUser.commitChanges { (err) in
                            if let err = err {
                                print("Could not set up user info. Err: \(err) ")
                                completion(false)
                            } else {
                                completion(true)
                            }
                        }
                    } else {
                        completion(false)
                    }
                } else {
                    for document in (snapshot?.documents)! {
                        if document.data()["username"] != nil {
                            self.displayAlert(title: "This username is already taken", message: "Please try a different username")
                            completion(false)
                            return
                        }
                    }
                }
            }
    }
    @IBAction func nextTapped(_ sender: UIButton) {
        guard nameTextFeild.text != "" else {
            displayAlert(title: "Error", message: "Please enter your name")
            return
        }
        guard usernameTextFeild.text != "" else {
            displayAlert(title: "Error", message: "Please enter a username")
            return
        }
        let range = NSRange(location: 0, length: nameTextFeild.text!.utf16.count)
        let regex = try! NSRegularExpression(pattern: "/^[a-z ,.'-]+$/i")
        // TODO - fix regex
        guard regex.firstMatch(in: nameTextFeild.text!, options: [], range: range) == nil  else {
            let alert = UIAlertController(title: "Please double check your name", message: "The name you chose was flagged by our algorithm. Is \"\(nameTextFeild.text!)\" your real name?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Yes thats me!", style: .default, handler: { action in
                self.varify() { completion in
                    if completion == false {
                        return
                    } else {
                        self.performSegue(withIdentifier: "next", sender: self)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

            self.present(alert, animated: true)
            return
        }
        
        self.varify() { completion in
            if completion == false {
                return
            } else {
                self.performSegue(withIdentifier: "next", sender: self)
            }
        }
    }
    @IBAction func backPressed(_ sender: UIButton) {
        
        let user = Auth.auth().currentUser

        //TODO - add loading screen
        user?.delete { error in
          if let error = error {
            print("failed to delete user")
            self.navigationController?.popViewController(animated: true)
          } else {
            self.navigationController?.popViewController(animated: true)
          }
        }
        
    }
    
}
