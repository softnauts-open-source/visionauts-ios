//
//  DatabaseMocked.swift
//  visionautsTests
//
//  Created by Piotr Błachewicz on 16/04/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import CoreData
@testable import visionauts

class DatabaseMocked {

    //MARK: - Mock in-memory core data stack
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let managedObject = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        return managedObject
    }()
    
    lazy var mockPersistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PersistentItems", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (description, error) in
            precondition(description.type == NSInMemoryStoreType)
            
            if let error = error {
                fatalError("Create an in-memory coordinator failed \(error)")
            }
        })
        return container
    }()
    
    //MARK: - Mock fetched results controller
    
    lazy var fetchedResultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<BeaconModel> in
        let fetchRequest: NSFetchRequest<BeaconModel> = BeaconModel.fetchRequest()
        
        fetchRequest.sortDescriptors = []
        
        let moc = mockPersistentContainer.viewContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    
    //MARK: - Flush data
    
    func flushData() {
        let fetchRequest = BeaconModel.fetchRequest() as NSFetchRequest<BeaconModel>
        let objs = try! mockPersistentContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistentContainer.viewContext.delete(obj)
        }
        
        try! mockPersistentContainer.viewContext.save()
    }
}

//MARK: - Helpers

public extension NSManagedObject {
    
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}
