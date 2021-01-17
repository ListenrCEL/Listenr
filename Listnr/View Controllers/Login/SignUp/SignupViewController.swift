//
//  SignupViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 12/9/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit
import Firebase

// Probly shouldnt be global but wtf
//TODO - make this not global
struct setupUser {
    var email: String?
    var password: String?
    var username: String?
    var name: String?
    var profileImage: UIImage?
    var privacyPolicy = Bool()
}
var setupData = setupUser()

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    @IBOutlet weak var confirmTextFeild: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.setTitle("Next", for: .normal)
        
        emailTextFeild.delegate = self
        passwordTextFeild.delegate = self
        confirmTextFeild.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    // TODO - make alert controller
    @IBAction func onNextButtonPressed(_ sender: UIButton) {
        guard setupData.privacyPolicy != false else {
            nextButton.setTitle("Create Acount", for: .normal)
            performSegue(withIdentifier: "privacyPolicy", sender: self)
            return
        }
        guard emailTextFeild.text != "" else {
            let alertController = UIAlertController(title: "Error", message: "Missing Email", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        guard passwordTextFeild.text != "" else {
            let alertController = UIAlertController(title: "Error", message: "Missing password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        guard confirmTextFeild.text != "" else {
            let alertController = UIAlertController(title: "Error", message: "You need to confirm password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        guard passwordTextFeild.text! == confirmTextFeild.text! else {
            let alertController = UIAlertController(title: "Error", message: "Passwords don't match", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        Auth.auth().createUser(withEmail: emailTextFeild.text!, password: passwordTextFeild.text!) { authResult, error in
            if error == nil {
                
                print("You have successfully signed up")
                self.performSegue(withIdentifier: "next", sender: self)
                
            } else {
                print(error)
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next" {
            
            let destinationVC = segue.destination as! Signup_DetailsViewController
            destinationVC.email = emailTextFeild.text!
            setupData.email = emailTextFeild.text!
            setupData.password = passwordTextFeild.text!
        }
    }
    @IBAction func backPressed(_ sender: UIButton) {
        setupData = setupUser()
        self.navigationController?.popViewController(animated: true)

    }
    
}

