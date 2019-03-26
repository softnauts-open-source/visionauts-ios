//
//  BeaconsService.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 20/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// Default service
class BeaconDefaultService: NSObject, BeaconServiceAdapter {

    var configuration: BeaconConfiguration!
    
    typealias BeaconType = CLBeacon
    typealias Manager = CLLocationManager
    
    // Location Delegate
    weak var delegate: LocationProtocol?
    
    // Location Manager
    var locationManager: CLLocationManager! = CLLocationManager()
    
    // Locating
    var isLocating: Bool = false
    
    // Shared instance
    static let shared = BeaconDefaultService()
    
    //MARK: - Init
    
    override init() {
        super.init()
        setUp()
    }
    
    //MARK: - Setup location manager
    
    func setUp() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    //MARK: - Start locating
    
    func startLocating() {
        print("startLocating")
        if CLLocationManager.isRangingAvailable() {
            guard let configuration = configuration else { return }
            guard !isLocating else { return }
            
            isLocating = true
            
            let myProximityUUID = UUID(uuidString: configuration.uuid)
            let beaconRegion = CLBeaconRegion(proximityUUID: myProximityUUID!, identifier: configuration.identifier)
            
            locationManager.startUpdatingLocation()
            
            // determining the presence of nearby beacons
            locationManager.startMonitoring(for: beaconRegion)
            
            // determining the proximity to nearby beacons
            locationManager.startRangingBeacons(in: beaconRegion)
        }
    }
    
    //MARK: - Stop locating
    
    func stopLocating() {
        guard let configuration = configuration else { return }
        isLocating = false
        
        let myProximityUUID = UUID(uuidString: configuration.uuid)
        let beaconRegion = CLBeaconRegion(proximityUUID: myProximityUUID!, identifier: configuration.identifier)
        
        locationManager.stopRangingBeacons(in: beaconRegion)
        locationManager.stopMonitoring(for: beaconRegion)
        locationManager.stopUpdatingLocation()
    }
}

//MARK: - CLLocation Manager Delegate

extension BeaconDefaultService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            ServiceFactory.permissions.locationIsActive = true
        }
        
        delegate?.didChangeAuthorizationStatus(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Location did enter region: \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Location did exit region: \(region)")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Location monitoring did for region: \(region)")
        delegate?.didStartMonitoringBeacons(in: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager did fail with error: \(error)")
        delegate?.locationMonitoringDidFail(with: error)
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("beacons found, count: \(beacons.count)")
        
        beacons.forEach { (beacon) in
            print("Beacon uuid: \(beacon.proximityUUID), minor: \(beacon.minor), major: \(beacon.major)")
        }

        delegate?.foundBeacons(beacons)
    }
}
