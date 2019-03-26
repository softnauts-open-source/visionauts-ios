//
//  BeaconServiceAdapter.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 21/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation
import CoreLocation

protocol BeaconServiceAdapter {
    associatedtype Manager
    
    var locationManager: Manager! { get }
    var delegate: LocationProtocol? { get set }
    var configuration: BeaconConfiguration! { get set }
    
    func startLocating()
    func stopLocating()
}

protocol LocationProtocol: class {
    func didChangeAuthorizationStatus(_ status: CLAuthorizationStatus)
    func foundBeacons(_ beacons: [CLBeacon])
    func didStartMonitoringBeacons(in region: CLRegion)
    func locationMonitoringDidFail(with error: Error)
}

struct BeaconConfiguration: Equatable {
    var uuid: String
    var identifier: String
    
    public static func == (lhs: BeaconConfiguration, rhs: BeaconConfiguration) -> Bool {
        guard lhs.uuid == rhs.uuid,
            lhs.identifier == rhs.identifier
            else {
                return false
        }
        
        return true
    }
}
