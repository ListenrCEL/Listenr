//
//  LoginViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 12/9/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextFeild.delegate = self
        passwordTextFeild.delegate = self
    }
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func showIncompleteAlert(username: String?) {
        let alert = UIAlertController(title: "Incomplete Acount", message: "We found your acount but it looks like you never completed signing up", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Continue sign up", style: .default, handler: { action in
            setupData.password = self.passwordTextFeild.text!
            setupData.email = self.emailTextFeild.text!
            
            if let username = username {
                setupData.username = username
            }
            
            self.performSegue(withIdentifier: "toAcountSetup", sender: self)
            return
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    // TODO - make alert controller
    @IBAction func onSubmitPressed(_ sender: UIButton) {
        sender.isEnabled = false
        self.navigationItem.backBarButtonItem?.isEnabled = false
        
        guard emailTextFeild.text != "" else {
            displayAlert(title: "Missing Email", message: "Please fill in email")
            sender.isEnabled = true
            self.navigationItem.backBarButtonItem?.isEnabled = true
            return
        }
        guard passwordTextFeild.text != "" else {
            displayAlert(title: "Missing Password", message: "Please fill in password")
            sender.isEnabled = true
            self.navigationItem.backBarButtonItem?.isEnabled = true
            return
        }
        Auth.auth().signIn(withEmail: emailTextFeild.text!, password: passwordTextFeild.text!){ (user, error) in
            
            guard error != nil else {
                let alertController = UIAlertController(title: "Error", message: "Incorect Email or Password", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                sender.isEnabled = true
                self.navigationItem.backBarButtonItem?.isEnabled = true
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            // Check if user is signed in. Idk why this wouldnt happen but it allows us to access the stored user metadata like the username. We then use the username to search for the firestore data attached to that username.
            if let user = Auth.auth().currentUser {
                // User could have not completed the sign up process. In this case we redirect them to signup
                guard let username = user.displayName else {
                    self.showIncompleteAlert(username: nil)
                    return
                }
                let db = Firestore.firestore()
                let docRef = db.collection("users").document(username)
                //get name, email, and username stored in Firestore from this username
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let name = document.get("name") as! String
                        let username = document.get("username") as! String
                        
                        //Download profile image from firebase storage
                        let storage = Storage.storage()
                        let imgRefrence = storage.reference(withPath: "\(username)/profileImage.jpg")
                        
                        imgRefrence.getData(maxSize: 1 * 10024 * 10024) { data, error in
                            if let error = error {
                                self.displayAlert(title: "Error", message: error.localizedDescription)
                                return
                            } else {
                                let image = UIImage(data: data!)
                                let data = User(name: name, username: username, stories: [], collections: [], profileImage: image!, subscribers: 0)
                                //store this in user defaults
                                setupAcount(user: data)
                                //Good to go!
                                self.performSegue(withIdentifier: "loginToTabBar", sender: self)
                            }
                        }
                    } else {
                        // couldnt find this data meaning user has not completed sign up process
                        self.showIncompleteAlert(username: username)
                        return
                    }
                }
            } else {
                self.displayAlert(title: "Oops, there was an issue logging in", message: "Try re-launching app")
            }

        }
        
    }
}
