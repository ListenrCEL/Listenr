//
//  SetupViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 1/15/21.
//  Copyright © 2021 Listnr. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SetupViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    @IBAction func onLoginTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toLogin", sender: self)
    }
    @IBAction func onSignupPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toSignUp", sender: self)
    }
    @IBAction func onDemoPressed(_ sender: UIButton) {
        setUpDemoMode()
        performSegue(withIdentifier: "toDemoMode", sender: self)
    }
    
    
}
