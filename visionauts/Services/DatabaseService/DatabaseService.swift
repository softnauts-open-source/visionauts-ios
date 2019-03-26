//
//  DatabaseService.swift
//  visionauts
//
//  Created by Renata Makuch on 12/03/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

// Service delegate protocols
protocol DatabaseBeaconsServiceProtocol: class {
    func getAllBeacons(from context: NSManagedObjectContext) -> [BeaconModel]
    func getBeaconsMatching(_ beacons: [CLBeacon], form context: NSManagedObjectContext) -> [BeaconModel]
    func getBeacon(by id: Int, from context: NSManagedObjectContext) -> BeaconModel?
    func saveBeacons(_ beaconsArray: [BeaconModel], context: NSManagedObjectContext)
}

class DatabaseService: NSObject {
    static let shared = DatabaseService()
}
