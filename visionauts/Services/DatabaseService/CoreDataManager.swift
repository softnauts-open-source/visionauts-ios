//
//  CoreDataManager.swift
//  visionauts
//
//  Created by Renata Makuch on 12/03/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    enum ContextType {
        case main
        case background
    }
    
    static let shared = CoreDataManager()
    
    ///private init preventing from creating another instance (meaning crash)
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleMainCoreDataChangeInBackgroundManagedContext(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: persistentContainer.viewContext)
    }
    
    //MARK: - Persistent Container
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "visionauts")
        
        let storeURL = try! FileManager
            .default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("visionauts.sqlite")
        
        ///Migration Lightweight
        let description = NSPersistentStoreDescription(url: storeURL)
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions =  [description]
        
        container.loadPersistentStores { (storeDescription, error) in
            print("[CoreData]: Store Description:\(storeDescription)")
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            
        }
        return container
    }()
    
    //MARK: - Background Managed Object Context
    
    lazy var backgroundManagedObjectContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
    
    //MARK: - Synchronize the background context
    
    @objc func handleMainCoreDataChangeInBackgroundManagedContext(notification: Notification){
        backgroundManagedObjectContext.mergeChanges(fromContextDidSave: notification)
    }
    
    //MARK: - Save context
    
    func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
                print("[CoreData]: Saved context")
            } catch {
                context.rollback()
                print("[CoreData]: Context rolled back")
            }
        } else {
            print("[CoreData]: Context has no changes to save")
        }
    }
    
    //MARK: - Helpers
    
    func getContext(_ contextType: ContextType) -> NSManagedObjectContext {
        switch contextType {
        case .main:
            return persistentContainer.viewContext
        case .background:
            return backgroundManagedObjectContext
        }
    }
}

//MARK: - Managed Object Context in Decoders

public extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
