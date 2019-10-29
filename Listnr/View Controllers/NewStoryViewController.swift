//
//  NewStoryViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 10/28/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class NewStoryViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate

    }
    override func viewWillAppear(_ animated: Bool) {
        if isBeingPresented {
            print("presenting")
        } else {
            print("not presenting")
            self.dismiss(animated: false, completion: nil)
        }
    }
    @IBAction func recordButton(_ sender: UIButton) {
    }
    
    @IBAction func onBackButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
