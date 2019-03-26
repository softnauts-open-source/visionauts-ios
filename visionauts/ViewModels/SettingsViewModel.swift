//
//  SettingsViewModel.swift
//  visionauts
//
//  Created by Renata Makuch on 20/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewModel {
    
    let settingsManager: SettingsManager!
    var setVoiceOverStatus: ((_ color: UIColor, _ text: String) -> Void)?
    var updateView: (() -> Void)?
    
    /// default value for range 50.0
    var currentRange: Float = 50.0 {
        didSet {
            updateView?()
        }
    }
    
    init(_ service: SettingsManager) {
        self.settingsManager = service
        let range = settingsManager.getRange() ?? currentRange
        currentRange = range
    }
    
    func getCurrentRange() -> Float {
       return currentRange
    }

    func getValueFromText(_ text: String) -> Float {
        if let value = Float(text) {
            return value
        }
        return 0.0
    }
    
    func saveRange(_ value: Float) -> Bool{
        if value >= 0 && value <= 100 {
            settingsManager.saveRange(value)
            currentRange = value
            return true
        }
        return false
    }
    
    func getTextFromValue(_ value: Float) -> String {
        return String(format: "%.0f", value)
    }
    
    func getVoiceOverStatus(_ isVoiceOver: Bool){
        if isVoiceOver {
            setVoiceOverStatus?(UIColor.hotGreen, "ON")
        } else {
            setVoiceOverStatus?(UIColor.redPink, "OFF")
        }
    }
}
