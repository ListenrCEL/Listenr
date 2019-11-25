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

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioPlayer()
    
    
    var audioPlayer: AVAudioPlayer?
    var audioURl: URL? = orangeFoot
    var queue: [story] = []
    
    private override init(){
        super.init()
        audioPlayer?.delegate = self
        
    }
    
    var isPlaying: Bool = false {
        willSet(value) {
            if value == true {
                setupAudio()
                guard let player = audioPlayer else { return }
                player.play()
            } else {
                guard let player = audioPlayer else { return }
                player.pause()
            }
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("song done")
        setupAudio()
        isPlaying = true
    }
    func setupAudio() {
        if queue.count != 0 {
            audioURl = queue.first?.storyURl
            queue.remove(at: queue.startIndex)
        }
        guard let url = audioURl else { print("error: failed to set up audio"); return }
        guard audioPlayer?.url?.absoluteString != url.absoluteString else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func rewind() {
        
    }
    func fastForward() {
        
    }
    
}
