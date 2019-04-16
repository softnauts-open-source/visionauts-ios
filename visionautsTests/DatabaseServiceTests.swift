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
    var database = DatabaseMocked()
    
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
        database.flushData()
        super.tearDown()
    }
    
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
                decoder.userInfo[codingUserInfoKeyManagedObjectContext] = self.database.mockPersistentContainer.viewContext
                
                _ = try!decoder.decode([BeaconModel].self, from: data)
                try! self.database.mockPersistentContainer.viewContext.save()
                
            case .failure(let message):
                XCTAssert(false, "reason: \(message)")
            }
        }
        
        waitForExpectations(timeout: 4.0, handler: nil)
    }
}
