//
//  Player.swift
//  Listnr
//
//  Created by Oliver Moscow on 11/9/19.
//  Copyright © 2019 Listnr. All rights reserved.
//

import UIKit
import AVFoundation

class Player {
    
    static let shared = Player()
    private init(){}
    
    // MARK: Outlets
    weak var playPauseButton: UIButton!
    weak var skipForwardButton: UIButton!
    weak var skipBackwardButton: UIButton!
    weak var progressBar: UIProgressView!
    weak var meterView: UIView!
    weak var volumeMeterHeight: NSLayoutConstraint!
    weak var countUpLabel: UILabel!
    weak var countDownLabel: UILabel!
    
    // MARK: AVAudio properties
    var engine = AVAudioEngine()
    var player = AVAudioPlayerNode()
    var rateEffect = AVAudioUnitTimePitch()
    
    var audioFile: AVAudioFile? {
        didSet {
            if let audioFile = audioFile {
                audioLengthSamples = audioFile.length
                audioFormat = audioFile.processingFormat
                audioSampleRate = Float(audioFormat?.sampleRate ?? 44100)
                audioLengthSeconds = Float(audioLengthSamples) / audioSampleRate
            }
        }
    }
    var audioFileURL: URL? {
        didSet {
            if let audioFileURL = audioFileURL {
                audioFile = try? AVAudioFile(forReading: audioFileURL)
            }
        }
    }
    var audioBuffer: AVAudioPCMBuffer?
    
    // MARK: other properties
    var audioFormat: AVAudioFormat?
    var audioSampleRate: Float = 0
    var audioLengthSeconds: Float = 0
    var audioLengthSamples: AVAudioFramePosition = 0
    var needsFileScheduled = true
    let rateSliderValues: [Float] = [0.5, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0]
    var rateValue: Float = 1.0 {
        didSet {
        }
    }
    var updater: CADisplayLink?
    var currentFrame: AVAudioFramePosition {
        guard
            let lastRenderTime = player.lastRenderTime,
            let playerTime = player.playerTime(forNodeTime: lastRenderTime)
            else {
                return 0
        }
        return playerTime.sampleTime
    }
    
    var skipFrame: AVAudioFramePosition = 0
    var currentPosition: AVAudioFramePosition = 0
    let pauseImageHeight: Float = 26.0
    let minDb: Float = -80.0
    
    enum TimeConstant {
        static let secsPerMin = 60
        static let secsPerHour = TimeConstant.secsPerMin * 60
    }
    
    // MARK: - ViewController lifecycle
    //
    func viewDidLoad() {
        countUpLabel.text = formatted(time: 0)
        countDownLabel.text = formatted(time: audioLengthSeconds)
        setupAudio()
        
        //    updater = CADisplayLink(target: self, selector: #selector(updateUI))
        //    updater?.add(to: .current, forMode: .defaultRunLoopMode)
        //    updater?.isPaused = true
        
    }
    
    func viewDidAppear(_ animated: Bool) {
    }
}

// MARK: - Actions
//
extension Player {
    
    @objc func playTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        if player.isPlaying {
          player.pause()
        } else {
          if needsFileScheduled {
            needsFileScheduled = false
            scheduleAudioFile()
          }
          player.play()
        }
    }
    func play() {
        player.play()
    }
    
    @objc func plus10Tapped(_ sender: UIButton) {
        guard let _ = player.engine else { return }
        seek(to: 10.0)
    }
    
    @objc func minus10Tapped(_ sender: UIButton) {
        guard let _ = player.engine else { return }
        needsFileScheduled = false
        seek(to: -10.0)
    }
    
    @objc func updateUI() {
        currentPosition = currentFrame + skipFrame
        currentPosition = max(currentPosition, 0)
        currentPosition = min(currentPosition, audioLengthSamples)
        
        progressBar.progress = Float(currentPosition) / Float(audioLengthSamples)
        let time = Float(currentPosition) / audioSampleRate
        countUpLabel.text = formatted(time: time)
        countDownLabel.text = formatted(time: audioLengthSeconds - time)
        
        if currentPosition >= audioLengthSamples {
            player.stop()
            updater?.isPaused = true
            playPauseButton.isSelected = false
            disconnectVolumeTap()
        }
        
    }
}

// MARK: - Display related
//
extension Player {
    
    func formatted(time: Float) -> String {
        var secs = Int(ceil(time))
        var hours = 0
        var mins = 0
        
        if secs > TimeConstant.secsPerHour {
            hours = secs / TimeConstant.secsPerHour
            secs -= hours * TimeConstant.secsPerHour
        }
        
        if secs > TimeConstant.secsPerMin {
            mins = secs / TimeConstant.secsPerMin
            secs -= mins * TimeConstant.secsPerMin
        }
        
        var formattedString = ""
        if hours > 0 {
            formattedString = "\(String(format: "%02d", hours)):"
        }
        formattedString += "\(String(format: "%02d", mins)):\(String(format: "%02d", secs))"
        return formattedString
    }
}

// MARK: - Audio
//
extension Player {
    func setupAudio() {
        audioFileURL = Bundle.main.url(forResource: "Orange_Foot", withExtension: "mp3")
        
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: audioFormat)
        engine.prepare()
        
        do {
            try engine.start()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func scheduleAudioFile() {
        guard let audioFile = audioFile else { return }
        
        skipFrame = 0
        player.scheduleFile(audioFile, at: nil) { [weak self] in
            self?.needsFileScheduled = true
        }
    }
    func connectVolumeTap() {
        
    }
    
    func disconnectVolumeTap() {
    }
    
    func seek(to time: Float) {
        guard
            let audioFile = audioFile,
            let updater = updater
            else {
                return
        }
        
        skipFrame = currentPosition + AVAudioFramePosition(time * audioSampleRate)
        skipFrame = max(skipFrame, 0)
        skipFrame = min(skipFrame, audioLengthSamples)
        currentPosition = skipFrame
        
        player.stop()
        
        if currentPosition < audioLengthSamples {
            updateUI()
            needsFileScheduled = false
            
            player.scheduleSegment(audioFile,
                                   startingFrame: skipFrame,
                                   frameCount: AVAudioFrameCount(audioLengthSamples - skipFrame),
                                   at: nil) { [weak self] in
                                    self?.needsFileScheduled = true
            }
            
            if !updater.isPaused {
                player.play()
            }
        }
    }
}
