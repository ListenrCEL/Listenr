//
//  NewStoryContinuedViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 11/4/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class NewStoryContinuedViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: outlets
    @IBOutlet weak var titleTextFeild: UITextField!
    @IBOutlet weak var anonymousSwitch: UISwitch!
    @IBOutlet weak var catigoryButton: UIButton!
    @IBOutlet weak var coverArtButton: UIButton!
    @IBOutlet weak var chosenImageView: UIImageView!
    @IBOutlet weak var coverArtStackView: UIStackView!
    @IBOutlet weak var addCategoryButton: UIButton!
    
    var date = String()
    var imagePicked = UIImage()
    var isAnImage: Bool = false
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.setNavigationBarHidden(true, animated: true)
        titleTextFeild.delegate = self
        chosenImageView.isHidden = true
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "d/M/yy"
        date = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        print(date)
    }
    
    // MARK: saveButtonPressed
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        guard titleTextFeild.text != "" else
        {
            let alertController = UIAlertController(title: "Error", message: "Missing Title", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        let title = titleTextFeild.text!
        var anonymous = Bool()
        if anonymousSwitch.isOn {
            anonymous = true
        } else {
            anonymous = false
        }
        let url = NewStoryViewController.getURL()
        if isAnImage == true {
            let theStory = story(title: title, creator: userData.data, coverArt: imagePicked, dateUploaded: date, anonomous: anonymous, storyURl: url)
            userData.data.stories.append(theStory)
            for indexPath in selectedCategories {
                categories[indexPath].stories.append(theStory)
            }
        } else {
            let theStory = story(title: title, creator: userData.data, coverArt: UIImage(named: "noImageIcon")!, dateUploaded: date, anonomous: anonymous, storyURl: url)
            userData.data.stories.append(theStory)
            for indexPath in selectedCategories {
                categories[indexPath].stories.append(theStory)
            }
        }
        dismiss(animated: false)
        // imageURL
        // MARK: FIREBASE
        // works
        uploadAudio()
        NotificationCenter.default.post(name: Notification.Name("saving"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("updatingPlayer"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
    }
    // MARK: imagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        imagePicked = image
        isAnImage = true
        chosenImageView.image = imagePicked
        chosenImageView.isHidden = false
        coverArtButton.setTitle("Change", for: .normal)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isAnImage = false
        picker.dismiss(animated: true, completion: nil)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    //MARK: actions
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    @IBAction func didSwipe(_ sender: UISwipeGestureRecognizer) {
        dismiss(animated: true)
    }
    @IBAction func downTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func swichChanged(_ sender: UISwitch) {
        if sender.isOn == true {
            coverArtStackView.isHidden = true
        } else {
            coverArtStackView.isHidden = false
        }
    }
    @IBAction func picturePicture(_ sender: UIButton) {
        importPicture()
    }
}
