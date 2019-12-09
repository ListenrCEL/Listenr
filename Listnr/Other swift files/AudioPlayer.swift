//
//  AudioPlayer.swift
//  Listnr
//
//  Created by Oliver Moscow on 11/8/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

struct queueItem {
    var currentStory = story()
    var currentCollection = collection()
    var profile = Bool()
}

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioPlayer()
    
    var audioPlayer: AVAudioPlayer?
    var queue: [queueItem] = []
    var history: [queueItem] = []
    var playedTime = String()
    var currentCollectionTitle = String()
    
    private override init(){
        super.init()
    }
    
    //MARK: - isPlaying
    var isPlaying: Bool = false {
        willSet(value) {
            NotificationCenter.default.post(name: Notification.Name("updatingPlayer"), object: nil)
            if value == true {
                setupAudio()
                guard let player = audioPlayer else { return }
                player.play()
            } else {
                guard let player = audioPlayer else { return }
                player.pause()
            }
        }
        didSet {
            if oldValue != isPlaying {
            }
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        next()
    }
    //MARK: - setupAudio
    func setupAudio() {
        var audioURL: URL? = nil
        if queue.count != 0 {
            audioURL = queue.first?.currentStory.storyURl
        }
        guard let url = audioURL else { print("error: failed to set up audio"); return }
        guard audioPlayer?.url?.absoluteString != url.absoluteString else {return}
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer?.delegate = self
        } catch let error {
            print(error.localizedDescription)
        }
    }
    //MARK: - Actions
    func next() {
        guard queue.count != 0 | 1 else {
            if queue.count == 1 {
//                history.insert(queue.first!, at: 0)
                queue.remove(at: 0)
            }
            audioPlayer?.stop()
            isPlaying = false
            audioPlayer = nil
            return
        }
        if queue.count != 0 {
            history.insert(queue.first!, at: 0)
            audioPlayer?.stop()
            queue.remove(at: 0)
            isPlaying = true
        }
    }
    func back() {
        if history.count != 0 {
            queue.insert(history.first!, at: 0)
            history.remove(at: 0)
            isPlaying = true
            NotificationCenter.default.post(name: Notification.Name("updatingPlayer"), object: nil)
        }
    }
    func rewind() {
        audioPlayer?.currentTime -= 30
    }
    func fastForward() {
        audioPlayer?.currentTime += 30
    }
    
}
