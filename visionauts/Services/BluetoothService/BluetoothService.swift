//
//  BluetoothService.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 26/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation
import CoreBluetooth

// Service delegate protocol
protocol BluetoothServiceDelegate: class {
    func bluetoothStateChange(isEnabled: Bool)
}

class BluetoothService: NSObject {
    // Shared instance
    static let shared = BluetoothService()
    
    // Delegate
    weak var delegate: BluetoothServiceDelegate?
    
    // Manager
    var btManager = CBCentralManager()
    
    //MARK: - Init
    
    override private init() {
        super.init()
        setUpManager()
    }
    
    //MARK: - Setup
    
    func setUpManager() {
        btManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    
    //MARK: - Availabilty status check
    
    func isBluetoothAvailable() -> Bool {
        switch btManager.state {
        case .poweredOn:
            return true
        case .poweredOff, .resetting, .unauthorized, .unknown, .unsupported:
            return false
        }
    }
}

//MARK: - Bluetooth Service Delegate

extension BluetoothService: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch btManager.state {
        case .poweredOn:
            delegate?.bluetoothStateChange(isEnabled: true)
        case .poweredOff, .resetting, .unauthorized, .unknown, .unsupported:
            delegate?.bluetoothStateChange(isEnabled: false)
        }
    }
}
