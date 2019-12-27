//
//  Signup_ImageViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 12/9/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class Signup_ImageViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var outsideView: UIView!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var camraView: UIView!
    @IBOutlet weak var previewView: UIImageView!
    @IBOutlet weak var libraryView: UIView!
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var isTakingPhoto: Bool = true
    var front: Bool = true
    var isAnImage: Bool = false
    var imagePicked = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         setupCamera()
    }
    //MARK setup camera
    func setupCamera() {
        isTakingPhoto = true
        previewView.isHidden = true
        photoButton.setImage(nil, for: .normal)
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        if front {
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
                else {
                    print("Unable to access front camera!")
                    return
            }
            do {
                let input = try AVCaptureDeviceInput(device: camera)
                stillImageOutput = AVCapturePhotoOutput()
                stillImageOutput = AVCapturePhotoOutput()

                if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                    captureSession.addInput(input)
                    captureSession.addOutput(stillImageOutput)
                    setupLivePreview()
                }
            }
            catch let error  {
                print("Error Unable to initialize back camera:  \(error.localizedDescription)")
            }
        } else {
            guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
                else {
                    print("Unable to access back camera!")
                    return
            }
            do {
                let input = try AVCaptureDeviceInput(device: camera)
                stillImageOutput = AVCapturePhotoOutput()
                stillImageOutput = AVCapturePhotoOutput()

                if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                    captureSession.addInput(input)
                    captureSession.addOutput(stillImageOutput)
                    setupLivePreview()
                }
            }
            catch let error  {
                print("Error Unable to initialize camera:  \(error.localizedDescription)")
            }
        }
    }
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        videoPreviewLayer.isGeometryFlipped = false
        camraView.layer.addSublayer(videoPreviewLayer)
        camraView.bringSubviewToFront(previewView)
        camraView.bringSubviewToFront(outsideView)
        camraView.bringSubviewToFront(photoView)
        camraView.bringSubviewToFront(libraryView)
        
        outsideView.layer.cornerRadius = outsideView.bounds.width / 2
        insideView.layer.cornerRadius = insideView.bounds.width / 2
        photoButton.layer.cornerRadius = photoButton.bounds.width / 2
        insideView.layer.borderColor = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        insideView.layer.borderWidth = 1
        libraryView.layer.cornerRadius = libraryView.bounds.width / 2
        
        photoView.layer.cornerRadius = photoView.bounds.width / 2
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.camraView.bounds
            }
        }
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        isTakingPhoto = false
        isAnImage = true
        let image = UIImage(data: imageData)
//        previewView.image = proccessImage(image: image!)
        previewView.image = image
        previewView.isHidden = false
        photoButton.setImage(UIImage(systemName: "gobackward"), for: .normal)
        setupData.profileImage = image!
    }
    func proccessImage(image: UIImage) -> UIImage {
        let screenWidth = UIScreen.main.bounds.size.width
        let width: CGFloat = image.size.width
        let hight: CGFloat = image.size.height
        let aspectRatio = screenWidth / width
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: screenWidth, height: screenWidth), false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.translateBy(x: 0, y: (screenWidth - (aspectRatio * hight)) * 0.5)
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 92.5), size: CGSize(width: screenWidth, height: hight * aspectRatio)))
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        previewView.image = img
        return previewView.image!
    }
    //MARK: Actions
    @IBAction func nextPressed(_ sender: UIButton) {
        guard isAnImage == true else { return }
        userData.data = User(name: setupData.name, username: setupData.username, stories: [], collections: [], profileImage: setupData.profileImage, subscribers: 0)
        performSegue(withIdentifier: "next", sender: self)
    }
    
    @IBAction func flipPressed(_ sender: UIButton) {
        front = !front
        setupCamera()
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        if isTakingPhoto == true {
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            stillImageOutput.capturePhoto(with: settings, delegate: self)
        } else {
            setupCamera()
        }
    }
    @IBAction func libraryButtonPressed(_ sender: UIButton) {
        importPicture()
    }
    //MARK: Image Picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        imagePicked = image
        isAnImage = true
        previewView.image = imagePicked
        previewView.isHidden = false
        
        setupData.profileImage = image
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
}
