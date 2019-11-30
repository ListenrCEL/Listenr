//
//  NewStoryViewController.swift
//  Listnr
//
//  Created by Oliver Moscow on 10/28/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit
import AVFoundation

class NewStoryViewController: UIViewController, AVAudioRecorderDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var insideRecordView: UIView!
    @IBOutlet weak var outsideRecordView: UIView!
    @IBOutlet weak var recordLabel: UILabel!
    
    var recordingSession: AVAudioSession!
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        self.loadFailUI()
                    }
                }
            }
        } catch {
            self.loadFailUI()
        }
    }
    // MARK: loadRecordingUI
    func loadRecordingUI() {
        AudioPlayer.shared.isPlaying = false
        bottomView.isHidden = true
        
        recordButton.layer.cornerRadius = recordButton.bounds.width / 2
        insideRecordView.layer.cornerRadius = insideRecordView.bounds.width / 2
        outsideRecordView.layer.cornerRadius = outsideRecordView.bounds.width / 2
        bottomView.layer.cornerRadius = 15
        
        outsideRecordView.layer.shadowColor = UIColor.black.cgColor
        outsideRecordView.layer.shadowRadius = 30
        outsideRecordView.layer.shadowOpacity = 0.5
        outsideRecordView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
    //MARK: loadFailUI
    func loadFailUI() {
        bottomView.isHidden = true
        let alertController = UIAlertController(title: "Recording failed", message: "Please ensure the app has access to your microphone", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: false, completion: nil)
            alertController.dismiss(animated: false, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
        return
    }
    //MARK: - StartRecording
    func startRecording() {
        bottomView.isHidden = true
        recordLabel.text = "Tap to Stop"
        
        do {
            try recordingSession.setCategory(.record)
        } catch {
            print("Error")
        }
        
        let audioURL = NewStoryViewController.getURL()
        print("audioURL\(audioURL.absoluteString)")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            recorder = try AVAudioRecorder(url: audioURL, settings: settings)
            recorder.delegate = self
            recorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    // MARK: finishRecording
    func finishRecording(success: Bool) {
        recorder.stop()
        recorder = nil
        
        do {
            try recordingSession.setCategory(.playback)
        } catch {
            print("Error")
        }
        
        if success {
            play()
            recordLabel.text = "Tap to Re-record"
            bottomView.isHidden = false
        } else {
            recordLabel.text = "Tap to Record"
            
            let ac = UIAlertController(title: "Record failed", message: "There was a problem recording your recording; please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    //MARK: - URL
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    class func getURL() -> URL {
        //let URL = userData.username
        let index = userData.data.stories.count
        return getDocumentsDirectory().appendingPathComponent("Cache_\(index).m4a")
    }
    //MARK: Play
    func play() {
        let path = NewStoryViewController.getURL()
        do
        {
            player = try AVAudioPlayer(contentsOf: path)
            player.play()
        }catch{
            print(error.localizedDescription)
        }
    }
    // MARK: recordTapped
    func recordTapped() {
        guard recordLabel.text != "Tap to Re-record" else {
            let alertController = UIAlertController(title: "Are you sure you want to record again?", message: "Your old recording will be permanently deleted", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                alertController.dismiss(animated: true, completion: nil)
                self.startRecording()
            }))
            alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
                alertController.dismiss(animated: true, completion: nil)
            }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        if recorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    //MARK: Saving
    @objc func saving() {
        dismiss(animated: true, completion: nil)
    }

    
    //MARK: - Actions
    @IBAction func recordButonPressed(_ sender: Any) {
        recordTapped()
    }
    @IBAction func exitButton(_ sender: Any) {
        var playing: Bool = false
        if recordLabel.text != "Tap to record" {
            if recordLabel.text != "Tap to Re-record" {
                playing = true
                recorder.pause()
            }
            let alertController = UIAlertController(title: "Abandon recording?", message: "Your hard work will not be saved", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
                alertController.dismiss(animated: false, completion: nil)
            }))
            alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
                alertController.dismiss(animated: true, completion: nil)
                if playing == true {
                    self.recorder.record()
                }
            }))
            self.present(alertController, animated: true, completion: nil)
            return
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func nextTapped(_ sender: UITapGestureRecognizer) {
        NotificationCenter.default.addObserver(self, selector: #selector(saving), name: Notification.Name("saving"), object: nil)
        performSegue(withIdentifier: "next", sender: self)
    }
}
