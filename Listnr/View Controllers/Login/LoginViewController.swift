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
            
            if error == nil {
                print("You have successfully signed up")
                self.performSegue(withIdentifier: "loginToTabBar", sender: self)
                
                
            } else {
                let alertController = UIAlertController(title: "Error", message: "Incorect Email or Password", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                sender.isEnabled = true
                self.navigationItem.backBarButtonItem?.isEnabled = true
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
