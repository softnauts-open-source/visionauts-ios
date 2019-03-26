//
//  DatabaseService+Beacons.swift
//  visionauts
//
//  Created by Renata Makuch on 12/03/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

extension DatabaseService: DatabaseBeaconsServiceProtocol {
    //MARK: - Get Beacons
    func getAllBeacons(from context: NSManagedObjectContext) -> [BeaconModel] {
        let fetchRequest = BeaconModel.fetchRequest() as NSFetchRequest<BeaconModel>
        
        do {
            let results = try context.fetch(fetchRequest)
            return results
        } catch {
            print("Failed fetching BeaconModel from \(fetchRequest.debugDescription)")
        }
        return []
    }
    
    //MARK: - Get Beacons Regognized
    
    func getBeaconsMatching(_ beacons: [CLBeacon], form context: NSManagedObjectContext) -> [BeaconModel] {
        let fetchRequest = BeaconModel.fetchRequest() as NSFetchRequest<BeaconModel>
        
        var predicates = [NSPredicate]()
        
        beacons.forEach { (beacon) in
            let predicate: NSPredicate = NSPredicate(format: "minor = %@", beacon.minor)
            predicates.append(predicate)
        }
        
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        fetchRequest.predicate = compoundPredicate
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                return results
            }
        } catch {
            print("Failed fetching Beacons from \(fetchRequest.debugDescription)")
        }
        return []
    }
    
    //MARK: - Get Beacon by ID
    func getBeacon(by id: Int, from context: NSManagedObjectContext) -> BeaconModel? {
        let fetchRequest = BeaconModel.fetchRequest() as NSFetchRequest<BeaconModel>
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        do {
            let results = try context.fetch(fetchRequest)
            if let result = results.first {
                return result
            } else {
                return nil
            }
        } catch let error as NSError {
            print("[CoreData] Error (id = \(id): \(error), \(error.userInfo)")
            return nil
        }
    }
    
    //MARK: - Save Beacons
    func saveBeacons(_ beaconsArray: [BeaconModel], context: NSManagedObjectContext) {
        guard let entity = NSEntityDescription.entity(forEntityName: "BeaconModel", in: context) else { return }
        
        //allowed attributes for override
        let allowedAttributes = entity.attributesByName
        
        beaconsArray.forEach { (newItem) in
            let fetchRequest = BeaconModel.fetchRequest() as NSFetchRequest<BeaconModel>
            fetchRequest.predicate = NSPredicate(format: "id = %d", newItem.id)
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 1 {
                    if let existingItem = results.first(where: { !$0.objectID.isTemporaryID }) {
                        if existingItem.updatedAt != newItem.updatedAt {
                            //update existing item
                            for (attrKey, _) in allowedAttributes {
                                existingItem.setValue(newItem.value(forKey: attrKey), forKey: attrKey)
                            }
                            
                            //override relationship
                            if let texts = newItem.texts?.allObjects as? [TextModel] {
                                existingItem.texts?.allObjects.forEach({ (text) in
                                    context.delete(text as! NSManagedObject)
                                })
                                existingItem.addToTexts(NSSet(array: texts))
                            }
                        }
                        
                        //delete temporary
                        context.delete(newItem)
                    }
                }
            } catch let error as NSError {
                print("[CoreData]: Could not fetch. \(error), \(error.userInfo)")
            }
        }
        CoreDataManager.shared.saveContext(context)
    }
}
