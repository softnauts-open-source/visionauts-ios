//
//  DatabaseServiceTests.swift
//  visionautsTests
//
//  Created by Piotr Błachewicz on 25/03/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import XCTest
import CoreData
@testable import visionauts

class DatabaseServiceTests: XCTestCase {

    var sut = ServiceFactory.databaseService
    
    // Notification for saving context
    var saveNotificationCompleteHandler: ((Notification) -> Void)?
    
    //MARK: - Tests invocation setup
    
    override func setUp() {
        super.setUp()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contextSaved(notification:)),
                                               name: NSNotification.Name.NSManagedObjectContextDidSave,
                                               object: nil)
    }

    override func tearDown() {
        NotificationCenter.default.removeObserver(self)
        flushData()
        super.tearDown()
    }

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
    
    //MARK: - Notification - saving context
    
    func expectationForSaveNotification() -> XCTestExpectation {
        let expect = expectation(description: "Context Saved")
        waitForSavedNotification { (notification) in
            expect.fulfill()
        }
        return expect
    }
    
    func waitForSavedNotification(completeHandler: @escaping ((Notification)->()) ) {
        saveNotificationCompleteHandler = completeHandler
    }
    
    func contextSaved( notification: Notification ) {
        saveNotificationCompleteHandler?(notification)
    }
    
    //MARK: - Tests
    
    func test_saving_items_from_api() {
        //Given
        let mockSuccess = BeaconsMock.getBeacons.mockSuccess
        _ = expectationForSaveNotification()
        expectation(forNotification: Notification.Name.NSManagedObjectContextDidSave, object: nil, handler: nil)
        
        //When
        ServiceFactory.apiService.apiMockRequest(BeaconsRouter.getBeacons, OAuth: false, requestDelay: 0, mockResponse: .success(value: mockSuccess)) { (response) in
            
            switch response {
                
            case .success(let value):
                XCTAssertTrue(value is JsonData, "did not received json")
                let json = value as! JsonData
                let items = json["items"] as! [[String : Any]]
                let data = try! JSONSerialization.data(withJSONObject: items, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext!
                let decoder = JSONDecoder()
                decoder.userInfo[codingUserInfoKeyManagedObjectContext] = self.mockPersistentContainer.viewContext
                
                _ = try!decoder.decode([BeaconModel].self, from: data)
                try! self.mockPersistentContainer.viewContext.save()
                
            case .failure(let message):
                XCTAssert(false, "reason: \(message)")
            }
        }
        
        waitForExpectations(timeout: 4.0, handler: nil)
    }
}

//MARK: - Helpers

extension DatabaseServiceTests {
    
    func flushData() {
        let fetchRequest = BeaconModel.fetchRequest() as NSFetchRequest<BeaconModel>
        let objs = try! mockPersistentContainer.viewContext.fetch(fetchRequest)
        for case let obj as NSManagedObject in objs {
            mockPersistentContainer.viewContext.delete(obj)
        }
        
        try! mockPersistentContainer.viewContext.save()
    }
}

public extension NSManagedObject {
    
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}
