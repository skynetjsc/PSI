//
//  AudioManager.swift
//  LianChat
//
//  Created by Mac on 1/20/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import AVFoundation
import UIKit

class AudioManager: NSObject {
    
    static let shared = AudioManager()
    
    var audioSession: AVAudioSession!
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer?
    
    var fileName: String = "recording.m4a" // file name to store in local for recording or url string for playing
    
    var setupSuccess: (() -> Void)?
    var failedRecord: ((String?) -> Void)?
    var recordSuccess: ((URL) -> Void)?
    var failedPlay: ((String?) -> Void)?
    var progressPlayer: ((Float) -> Void)?
    
    override init() {
        super.init()
        self.audioSession = AVAudioSession.sharedInstance()
    }
}

// MARK: = Record

extension AudioManager {
    
    public func setupRecord(fileName: String = "audio_\(Date().timeIntervalSince1970).m4a") {
        self.fileName = fileName
        self.requestPermission()
    }
    
    private func requestPermission() {
        do {
            try self.audioSession.setCategory(.playAndRecord, mode: .default)
            try self.audioSession.setActive(true)
            self.audioSession.requestRecordPermission() { [weak self] allowed in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    if allowed {
                        self.setupSuccess?()
                    } else {
                        self.failedRecord?("Requesting the permission failed")
                    }
                }
            }
        } catch let error {
            self.failedRecord?(error.localizedDescription)
        }
    }
    
    func getFileUrl() -> URL {
        return getDocumentsDirectory().appendingPathComponent(fileName)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func startRecording(completion: (() -> Void)? = nil) {
        let audioFilename = getFileUrl()
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            completion?()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func pauseRecording() {
        if audioRecorder != nil {
            audioRecorder.pause()
        }
    }
    
    func resumeRecording() {
        if audioRecorder != nil {
            audioRecorder.record()
        }
    }
    
    func stopRecording() {
        if audioRecorder != nil {
            audioRecorder.stop()
            audioRecorder = nil
        }
    }
    
    func finishRecording(success: Bool) {
        if audioRecorder != nil {
            audioRecorder.stop()
            audioRecorder = nil
            
            if success {
                self.recordSuccess?(getFileUrl())
            } else {
                self.failedRecord?(nil)
            }
        }
    }
    
    func deleteRecordingFile() {
        if audioRecorder != nil {
            audioRecorder.stop()
            audioRecorder.deleteRecording()
            audioRecorder = nil
        }
    }
}

// MARK: = AVAudioRecorderDelegate
extension AudioManager: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}

// MARK: = Player
extension AudioManager {
    
    func setupPlay(urlString: String) {
        self.fileName = urlString
    }
    
    func playSound() {
        if let audioPlayer = audioPlayer, audioPlayer.isPlaying { audioPlayer.stop() }
        
        guard let soundURL = URL(string: self.fileName) else {
            self.failedPlay?("Playing the audio failed")
            return
        }
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
            try audioSession.setActive(true)
            let data = try Data(contentsOf: soundURL)
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.delegate = self
            audioPlayer?.isMeteringEnabled = true
            audioPlayer?.prepareToPlay()
            enableTimer()
            audioPlayer?.play()
        } catch let error {
            self.failedPlay?(error.localizedDescription)
        }
    }
    
    func forward() {
        guard let audioPlayer = self.audioPlayer else { return }
        
        var time: TimeInterval = audioPlayer.currentTime
        time += 5.0
        if time > audioPlayer.duration {
            // stop, track skip or whatever you want
        } else {
            audioPlayer.currentTime = time
        }
    }
    
    func pausePlay() {
        guard let audioPlayer = self.audioPlayer else { return }
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }
    
    func resumePlay() {
        guard let audioPlayer = self.audioPlayer else { return }
        audioPlayer.play()
    }
    
    func replay() {
        if audioPlayer != nil {
            audioPlayer = nil
            self.playSound()
        }
    }
    
    func stopPlay() {
        if audioPlayer != nil {
            audioPlayer?.stop()
        }
    }
    
    func enableTimer() {
        if audioPlayer != nil {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
                guard let audioPlayer = self.audioPlayer else {
                    timer.invalidate()
                    return
                }
                
                audioPlayer.updateMeters() // refresh state
                let progress = Float(audioPlayer.currentTime / audioPlayer.duration)
                self.progressPlayer?(progress)
                if progress >= 1 {
                    self.progressPlayer?(1.0)
                    timer.invalidate()
                }
            }
        }
    }
}

// MARK: - AVAudioPlayerDelegate
extension AudioManager: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.progressPlayer?(1.0)
    }
}




