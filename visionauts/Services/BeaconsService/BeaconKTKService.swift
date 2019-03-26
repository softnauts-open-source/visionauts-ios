//
//  BeaconKTService.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 21/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation
import KontaktSDK

class BeaconKTKService: NSObject, BeaconServiceAdapter {
    var configuration: BeaconConfiguration!
    
    typealias Manager = KTKBeaconManager
    
    // Location Manager
    var locationManager: KTKBeaconManager!
    
    // Location Delegate
    weak var delegate: LocationProtocol?
    
    // Shared instance
    static let shared = BeaconKTKService()
    
    //MARK: - Init
    
    override init() {
        super.init()
        locationManager = KTKBeaconManager(delegate: self)
    }
    
    func startLocating() {
        let myProximityUUID = UUID(uuidString: configuration.uuid)
        let region = KTKBeaconRegion(proximityUUID: myProximityUUID!, identifier: configuration.identifier)
        
        if KTKBeaconManager.isMonitoringAvailable() {
            locationManager.startMonitoring(for: region)
        }
    }
    
    func stopLocating() {
        let myProximityUUID = UUID(uuidString: configuration.uuid)
        let region = KTKBeaconRegion(proximityUUID: myProximityUUID!, identifier: configuration.identifier)
        locationManager.stopMonitoring(for: region)
    }
}

//MARK: - KTK Manager Delegate

extension BeaconKTKService: KTKBeaconManagerDelegate {
    
    func beaconManager(_ manager: KTKBeaconManager, didStartMonitoringFor region: KTKBeaconRegion) {
        // Do something when monitoring for a particular
        // region is successfully initiated
        print("Location Monitoring did start! Region: \(region)")
    }
    
    func beaconManager(_ manager: KTKBeaconManager, monitoringDidFailFor region: KTKBeaconRegion?, withError error: Error?) {
        if let error = error {
            print("Location Monitoring did fail: \(error.localizedDescription)")
            delegate?.locationMonitoringDidFail(with: error)
        }
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didEnter region: KTKBeaconRegion) {
        print("Enter region \(region)")
        manager.startRangingBeacons(in: region)
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didExitRegion region: KTKBeaconRegion) {
        print("Exit region \(region)")
        manager.stopRangingBeacons(in: region)
    }
    
    func beaconManager(_ manager: KTKBeaconManager, didRangeBeacons beacons: [CLBeacon], in region: KTKBeaconRegion) {
        print("Ranged beacons count: \(beacons.count)")
        delegate?.foundBeacons(beacons)
    }
}
