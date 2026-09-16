//
//  AlterFeedback.swift
//  DraftClock
//
//  Created by Joshua Beckom on 9/13/26.
//

import AVFoundation
import UIKit

@MainActor
final class AlertFeedback {
    private var audioPlayer: AVAudioPlayer?
    
    func triggerExpirationFeedback() {
        playSound(named: "timer-expired")
        triggerHaptic()
    }
    
    func triggerWarningFeedback() {
        playSound(named: "timer-tick")
    }
    
    private func playSound(named soundName: String) {
        guard let soundURL = Bundle.main.url(
            forResource: soundName,
            withExtension: "wav"
        ) else {
            print("Could not find timer-expired.wav")
            return
        }
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            
            try audioSession.setCategory (
                .playback,
                mode: .default
            )
            
            try audioSession.setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Unable to play expiration sound: \(error)")
        }
    }
    
    private func triggerHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
    }
}
