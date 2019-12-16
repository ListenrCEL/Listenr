//
//  SignupViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 12/9/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

// Probly shouldnt be global but wtf
struct setupUser {
    var email = String()
    var password = String()
    var username = String()
    var name = String()
    var age = Int()
    var profileImage = UIImage()
}
var setupData = setupUser()

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    @IBOutlet weak var confirmTextFeild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextFeild.delegate = self
        passwordTextFeild.delegate = self
        confirmTextFeild.delegate = self
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    // TODO - make alert controller
    @IBAction func onNextButtonPressed(_ sender: UIButton) {
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
        performSegue(withIdentifier: "next", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "next" {
            setupData.email = emailTextFeild.text!
            setupData.password = passwordTextFeild.text!
        }
    }
}

