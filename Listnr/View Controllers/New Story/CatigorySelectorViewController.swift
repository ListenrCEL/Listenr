//
//  CatigorySelectorViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 11/5/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit

var selectedCategories = IndexPath()

class CatigorySelectorViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    var selectedCells: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesCollectionView.allowsMultipleSelection = true
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CatigorySelectorCollectionViewCell
        cell.Image.image = categories[indexPath.row].coverArt
        cell.label.text = categories[indexPath.row].title
        let color = categories[indexPath.row].coverArt.averageColor
        if (color!.isLight())! {
            cell.label.textColor = .black
            cell.checkMark.tintColor = .black
        } else {
            cell.label.textColor = .white
            cell.checkMark.tintColor = .white
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CatigorySelectorCollectionViewCell
        if cell.isSelected == true {
            doneButton.isHidden = false
            doneButton.isEnabled = true
            cell.checkMark.isHidden = false
            selectedCells.append(cell.label.text!)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CatigorySelectorCollectionViewCell
        cell.checkMark.isHidden = true
        selectedCells.remove(at: 0)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.bounds.width - 40
        return CGSize(width: size / 3, height: 120)
    }
    @IBAction func exitPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func donePressed(_ sender: UIButton) {
        guard selectedCells.count != 0 else {
            return
        }
        guard selectedCells.count <= 3 else {
            let alertController = UIAlertController(title: "To Many Items", message: "Pick up to three", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        for indexPath in categoriesCollectionView.indexPathsForSelectedItems! {
            selectedCategories.append(indexPath.item)
        }
        dismiss(animated: true)
    }
}
