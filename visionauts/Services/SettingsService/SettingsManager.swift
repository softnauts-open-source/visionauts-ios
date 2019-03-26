//
//  SettingsManager.swift
//  visionauts
//
//  Created by Renata Makuch on 21/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit

class SettingsManager: NSObject {
    
    static let shared = SettingsManager()
    
    func saveRange(_ value: Float) {
        UserDefaults.standard.set(value, forKey: "bluetoothRange")
    }
    
    func getRange() -> Float? {
        if let value = UserDefaults.standard.value(forKey: "bluetoothRange") as? Float {
            return value
        }
        return nil
    }
}
