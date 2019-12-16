//
//  Signup_DetailsViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 12/9/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class Signup_DetailsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextFeild: UITextField!
    @IBOutlet weak var usernameTextFeild: UITextField!
    @IBOutlet weak var ageTextFeild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextFeild.delegate = self
        usernameTextFeild.delegate = self
        ageTextFeild.delegate = self
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
            setupData.username = nameTextFeild.text!
            setupData.age = Int(ageTextFeild.text!)!
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
    @IBAction func nextTapped(_ sender: UIButton) {
        guard nameTextFeild.text != "" else {
            displayAlert(title: "Error", message: "Please enter your name")
            return
        }
        guard usernameTextFeild.text != "" else {
            displayAlert(title: "Error", message: "Please enter a username")
            return
        }
        guard ageTextFeild.text != "" else {
            displayAlert(title: "Error", message: "Please enter your name")
            return
        }
        let age: Int? = Int(ageTextFeild.text!)
        guard age! >= 13 else {
            displayAlert(title: "Error", message: "You must be older than 13 to use this app")
            return
        }
        performSegue(withIdentifier: "next", sender: self)
    }
}
