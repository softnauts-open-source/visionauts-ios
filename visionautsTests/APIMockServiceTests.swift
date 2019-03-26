//
//  APIMockServiceTests.swift
//  visionautsTests
//
//  Created by Piotr Błachewicz on 20/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import XCTest
@testable import visionauts

class APIMockServiceTests: XCTestCase {

    var sut: NetworkManager?
    
    override func setUp() {
        super.setUp()
        sut = NetworkManager.shared
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_fetching_mock_beacons_with_success() {
        //Given
        let sut = self.sut!
        let mockSuccess = BeaconsMock.getBeacons.mockSuccess
        
        //When
        let expect = XCTestExpectation(description: "success callback")
        
        sut.apiMockRequest(BeaconsRouter.getBeacons, OAuth: false, requestDelay: 1.0, mockResponse: .success(value: mockSuccess)) { (response) in
        
            switch response {
                
            case .success(let value):
                XCTAssertTrue(value is JsonData, "did not received json")
            case .failure(let message):
                XCTAssert(false, "reason: \(message)")
            }
            
            expect.fulfill()
        }
        wait(for: [expect], timeout: 2.0)
    }
    
    func test_fetching_mock_beacons_with_failure() {
        //Given
        let sut = self.sut!
        let mockFailure = BeaconsMock.getBeacons.mockFailure
        
        //When
        let expect = XCTestExpectation(description: "failure callback")
        
        sut.apiMockRequest(BeaconsRouter.getBeacons, OAuth: false, mockResponse: .failure(error: mockFailure)) { (response) in
            
            switch response {
                
            case .success(_):
                XCTAssert(false, "this shouldn't be success")
            case .failure(_):
                expect.fulfill()
            }
        }
        
        wait(for: [expect], timeout: 1.0)
    }
}
