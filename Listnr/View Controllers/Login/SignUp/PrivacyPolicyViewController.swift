//
//  PrivacyPolicyViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 12/25/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {
    //TODO - make this work withought data
    
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var ageCheckBox: UIButton!
    @IBOutlet weak var privacyCheckBox: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var age: Bool = false
    var privacy: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://docs.google.com/document/d/1fBIb1v6XTrElgPp5ITJL2t7gQFNCbdgiBDJVuepN0dU/edit?usp=sharing")
        webview.load(URLRequest(url: url!))
        
        showCancel()
    }
    func showCancel() {
        nextButton.backgroundColor = .red
        nextButton.setTitle("Cancel", for: .normal)
    }
    func showNext(){
        nextButton.backgroundColor = .blue
        nextButton.setTitle("Next", for: .normal)
    }
    @IBAction func ageCheckBoxPressed(_ sender: UIButton) {
        age = !age
        if age == true{
            sender.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            if privacy == true {
                showNext()
            }
        } else {
            sender.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
            showCancel()
        }
    }
    @IBAction func privacyCheckboxPressed(_ sender: UIButton) {
        privacy = !privacy
        if privacy == true {
            sender.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
            if age == true {
                showNext()
            }
        } else {
            sender.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
            showCancel()
        }
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        if sender.title(for: .normal) == "Next" {
            guard age == true else { return }
            guard privacy == true else { return }
            dismiss(animated: true) {
                setupData.privacyPolicy = true
            }
            
        } else {
            dismiss(animated: true)
        }
    }
}
