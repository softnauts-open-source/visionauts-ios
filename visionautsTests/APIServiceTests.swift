//
//  APIServiceTests.swift
//  visionautsUITests
//
//  Created by Piotr Błachewicz on 19/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import XCTest
@testable import visionauts

class APIServiceTests: XCTestCase {

    var sut: NetworkManager?
    
    override func setUp() {
        super.setUp()
        sut = NetworkManager.shared
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_fetching_beacons_from_api_with_success() {
        //Given
        let sut = self.sut!
        
        //When
        let expect = XCTestExpectation(description: "callback")
        
        sut.apiRequest(BeaconsRouter.getBeacons, OAuth: false) { (response) in
            expect.fulfill()
            
            var responseJson: JsonArrayData?
            
            switch response {
                
            case .success(let value):
                responseJson = value as? JsonArrayData
                XCTAssertNotNil(responseJson)
            case .failure(let message):
                print(message)
                XCTAssert(false, "Request failure")
            }
        }
        wait(for: [expect], timeout: 4.0)
    }
    
}
