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

class AudioPlayer {
    static let shared = AudioPlayer()
    private init(){}
    
    var audioPlayer: AVAudioPlayer?
    var audioURl: URL? = orangeFoot
    
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
    func setupAudio() {
        guard let url = audioURl else { print("failed to play audio"); return }
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
