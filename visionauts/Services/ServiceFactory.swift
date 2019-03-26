//
//  ServiceFactory.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 20/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation

struct ServiceFactory {
    static var apiService: NetworkManager {
        return NetworkManager.shared
    }
    
    static var settingsService: SettingsManager {
        return SettingsManager.shared
    }
    
    static var bluetoothService: BluetoothService {
        return BluetoothService.shared
    }

    static var databaseService: DatabaseService {
        return DatabaseService.shared
    }
    
    static var permissions: PermissionsService {
        return PermissionsService.shared
    }

    static var voiceSynthesizerService: VoiceSynthesizerService {
        return VoiceSynthesizerService.shared
    }
    
    static func beaconDefaultService(_ configuration: BeaconConfiguration? = nil) -> BeaconDefaultService {
        return self.beaconService(provider: .defaultService, configuration)
    }
    
    static func beaconKontaktService(_ configuration: BeaconConfiguration? = nil) -> BeaconKTKService {
        return self.beaconService(provider: .kontakt, configuration)
    }
}
