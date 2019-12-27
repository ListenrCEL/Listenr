//
//  NewCollectionViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 11/21/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

class NewCollectionViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePicked = UIImage()
    var isAnImage: Bool = false
    
    @IBOutlet weak var chosenImageView: UIImageView!
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var coverArtButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextView.delegate = self
        chosenImageView.isHidden = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
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
        
    func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
        
    }
    @IBAction func savePressed(_ sender: UIButton) {
       guard titleTextView.text != "" else
        {
            let alertController = UIAlertController(title: "Error", message: "Missing Title", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        if isAnImage {
            userData.data.collections.append(collection(stories: newCollectionArray, title: titleTextView.text!, creator: userData.data, coverArt: imagePicked))
        } else {
            userData.data.collections.append(collection(stories: newCollectionArray, title: titleTextView.text!, creator: userData.data, coverArt: UIImage(named: "Image1")!))
        }
        NotificationCenter.default.post(name: Notification.Name("reload"), object: nil)
        dismiss(animated: true)
    }
    @IBAction func addImage(_ sender: Any) {
        importPicture()
    }
    
}
