//
//  DetectingBeaconsViewModelTests.swift
//  visionautsTests
//
//  Created by Piotr Błachewicz on 16/04/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import XCTest
import CoreData
import CoreLocation
@testable import visionauts

class DetectingBeaconsViewModelTests: XCTestCase {

    let sut = DetectingBeaconsViewModel()
    let database = DatabaseMocked()
    
    override func tearDown() {
        database.flushData()
        super.tearDown()
    }
    
    func test_items() {
        //Given
        let items = mockBeaconModels()

        //When
        sut.items = items
        
        //Then
        XCTAssertEqual(sut.items, items)
    }
    
    func test_getting_current_item() {
        //Given
        sut.items = mockBeaconModels()
        
        //When
        let currentItem = sut.getCurrentItem()
        
        //Then
        XCTAssertNotNil(currentItem)
        XCTAssertEqual(currentItem, sut.items[sut.currentItemIndex])
    }
    
    func test_getting_current_item_when_no_items() {
        //Given sut
        
        //When
        let currentItem = sut.getCurrentItem()
        
        //Then
        XCTAssertNil(currentItem)
    }
}

//MARK: - Helpers

extension DetectingBeaconsViewModelTests {
    
    func mockBeaconModels() -> [BeaconModel] {
        let jsonItems = BeaconsMock.getBeacons.mockSuccess
        let mockItems = jsonItems["items"]
        let data = try! JSONSerialization.data(withJSONObject: mockItems!, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext!
        let decoder = JSONDecoder()
        decoder.userInfo[codingUserInfoKeyManagedObjectContext] = database.mockPersistentContainer.viewContext
        let items = try! decoder.decode([BeaconModel].self, from: data)
        return items
    }
}
