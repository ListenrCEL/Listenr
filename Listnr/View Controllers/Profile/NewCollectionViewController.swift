//
//  NewCollectionViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 11/21/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class NewCollectionViewController: UIViewController {
    
    var colors: [UIColor] = [
        UIColor(red: 1.28, green: 0.16, blue: 1.02, alpha: 1.00),
        UIColor(red: 1.18, green: 0.85, blue: 1.12, alpha: 1.00),
        UIColor(red: 1.56, green: 1.49, blue: 0.61, alpha: 1.00),
    ]
    
    @IBOutlet weak var titleTextView: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
        
    }
    @IBAction func savePressed(_ sender: UIButton) {
        print(colors[userData.collections.count])
        userData.collections.append(collection(stories: newCollectionArray, title: titleTextView.text!, creator: userData.name))
        dismiss(animated: true)
    }
    @IBAction func colorSelector(_ sender: UIButton) {
    }
    
}
