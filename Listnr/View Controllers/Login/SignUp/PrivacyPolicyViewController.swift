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
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var ageCheckBox: UIButton!
    @IBOutlet weak var privacyCheckBox: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    var age: Bool = false
    var privacy: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = .zero
        containerView.layer.shadowRadius = 5
        if let rtfPath = Bundle.main.url(forResource: "Listnr Privacy Policy", withExtension: "rtf") {
                do {
                    let attributedStringWithRtf: NSAttributedString = try NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                    self.textView.attributedText = attributedStringWithRtf
                } catch let error {
                    print("Got an error \(error)")
                }
            }
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
