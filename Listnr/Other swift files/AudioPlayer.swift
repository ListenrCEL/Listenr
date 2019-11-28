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
import MediaPlayer

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    static let shared = AudioPlayer()
    
    
    var audioPlayer: AVAudioPlayer?
    var audioURl: URL? = orangeFoot
    var queue: [story] = []
    var history: [story] = []
    var playedTime = String()
    
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
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        next()
    }
    //MARK: - setupAudio
    func setupAudio() {
        if queue.count != 0 {
            audioURl = queue.first?.storyURl
        }
        guard let url = audioURl else { print("error: failed to set up audio"); return }
        guard audioPlayer?.url?.absoluteString != url.absoluteString else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer?.delegate = self
//            setupNotificationView()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    //MARK: - notificationView
//    func setMediaPlayerNotificationView() {
//        let commandCenter = MPRemoteCommandCenter.shared()
//        commandCenter.playCommand.addTarget { [unowned self] event in
//            self.play()
//            return .success
//        }
//        commandCenter.pauseCommand.addTarget{ [unowned self] event in
//            self.pause()
//            return .success
//        }
//        commandCenter.previousTrackCommand.addTarget{ [unowned self] event in
//            self.back()
//            return .success
//        }
//        commandCenter.previousTrackCommand.addTarget{ [unowned self] event in
//            self.forward()
//            return .success
//        }
//    }
    func setupNotificationView() {
        var nowPlayingInfo = [String: Any]()
                
        nowPlayingInfo[MPMediaItemPropertyTitle] = "queue[0].title"
        nowPlayingInfo[MPMediaItemPropertyArtist] = "queue[0].creator"
//        nowPlayingInfo[MPMediaItemPropertyArtwork] = queue[0].coverArt
        
//        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem.asset.duration.seconds
//        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
//        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerItem.currentTime().seconds
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    //MARK: - Actions
    func play() {
        isPlaying = true
    }
    func pause() {
        isPlaying = false
    }
    func next() {
        if queue.count != 1 {
            history.insert(queue.first!, at: 0)
            if queue.count != 0 {
                audioPlayer?.stop()
                queue.remove(at: 0)
                isPlaying = true
                NotificationCenter.default.post(name: Notification.Name("updatingPlayer"), object: nil)
            }
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
