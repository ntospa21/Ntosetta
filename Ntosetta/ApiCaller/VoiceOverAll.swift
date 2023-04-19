//
//  VoiceOverAll.swift
//  Ntosetta
//
//  Created by Pantos, Thomas on 2/2/23.
//

import Foundation
import AVFoundation

class SpeechSynthesizer: NSObject, AVSpeechSynthesizerDelegate {
    var speechSynthesizer = AVSpeechSynthesizer()
    var speechUtterance = AVSpeechUtterance(string: "")
    
    func startSpeaking(_ text: String) {
        speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
    }
    
    func stopSpeaking() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
}


