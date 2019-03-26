//
//  PermissionsService.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 14/03/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation

protocol PermissionsServiceProtocol {
    func didChangeLocationAuthorizationStatus(value: Bool)
    func didChangeBluetoothAvailabilityStatus(value: Bool)
}

class PermissionsService: PermissionsServiceProtocol {
    
    var locationIsActive: Bool = false {
        didSet {
            handlePermissionChange()
        }
    }
    
    var bluetoothIsActive: Bool = false {
        didSet {
            handlePermissionChange()
        }
    }
    
    static let shared = PermissionsService()
    
    private init() {}
    
    func didChangeLocationAuthorizationStatus(value: Bool) {
        locationIsActive = value
    }
    
    func didChangeBluetoothAvailabilityStatus(value: Bool) {
        bluetoothIsActive = value
    }
    
    func handlePermissionChange() {
        if locatingAllowed() {
            ServiceFactory.beaconDefaultService().startLocating()
        } else {
            ServiceFactory.beaconDefaultService().stopLocating()
        }
    }
    
    func locatingAllowed() -> Bool {
        return locationIsActive && bluetoothIsActive
    }
}
