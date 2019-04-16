//
//  BeaconsViewModel.swift
//  visionauts
//
//  Created by Renata Makuch on 12/03/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit

class BeaconsViewModel {
    
    //MARK: - Parse
    
    func saveBeacons(_ data: Data) {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
            fatalError("Failed to retrieve context")
        }
        
        let managedObjectContext = CoreDataManager.shared.getContext(.main)
        let decoder = JSONDecoder()
        decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
        
        do {
            let beaconsArray = try decoder.decode([BeaconModel].self, from: data)
            ServiceFactory.databaseService.saveBeacons(beaconsArray, context: managedObjectContext)
        } catch let error {
            print("Error getBeacons: \(error)")
            print("Error retrieving Beacon models")
        }
    }
}
