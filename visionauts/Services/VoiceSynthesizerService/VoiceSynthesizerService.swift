//
//  VoiceSynthesizerService.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 24/03/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

protocol VoiceSynthesizerProtocol: class {
    func speak(_ text: String)
    func stopSpeaking()
}

class VoiceSynthesizerService: VoiceSynthesizerProtocol {
    
    static let shared = VoiceSynthesizerService()
    
    // Synthesizer
    let synthesizer = AVSpeechSynthesizer()
    
    //MARK: - Synthesizer Action
    
    func speak(_ text: String) {
        guard !UIAccessibility.isVoiceOverRunning else { return }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: NSLocale.current.languageCode)
        
        if synthesizer.isSpeaking {
            stopSpeaking()
        }
        synthesizer.speak(utterance)
    }
    
    func stopSpeaking() {
        guard synthesizer.isSpeaking else { return }
        synthesizer.stopSpeaking(at: .immediate)
    }
}
