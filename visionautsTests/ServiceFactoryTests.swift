//
//  ServiceFactoryTests.swift
//  visionautsTests
//
//  Created by Piotr Błachewicz on 26/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import XCTest
@testable import visionauts

class ServiceFactoryTests: XCTestCase {

    typealias sut = ServiceFactory

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut.beaconDefaultService().configuration = nil
        sut.beaconKontaktService().configuration = nil
        super.tearDown()
    }
    
    func test_api_service_not_nil() {
        //Given
        let apiService = sut.apiService
        
        XCTAssertNotNil(apiService)
    }
    
    func test_settings_service_not_nil() {
        //Given sut
        
        //When
        let settingsService = sut.settingsService
        
        XCTAssertNotNil(settingsService)
    }
    
    func test_bluetooth_service_not_nil() {
        //Given sut
        
        //When
        let btService = sut.bluetoothService
        
        XCTAssertNotNil(btService)
    }
    
    func test_database_service_not_nil() {
        //Given sut
        
        //When
        let dbService = sut.databaseService
        
        XCTAssertNotNil(dbService)
    }
    
    func test_voice_synthesizer_service_not_nil() {
        //Given sut
        
        //When
        let voiceSynthService = sut.voiceSynthesizerService
        
        XCTAssertNotNil(voiceSynthService)
    }
    
    func test_beacons_default_service_not_nil() {
        //Given
        let configuration = BeaconConfiguration(uuid: "", identifier: "")
        
        //When
        let service = sut.beaconDefaultService(configuration)
        
        XCTAssertNotNil(service)
    }
    
    func test_beacons_ktk_service_not_nil() {
        //Given
        let configuration = BeaconConfiguration(uuid: "", identifier: "")
        
        //When
        let service = sut.beaconKontaktService(configuration)
        
        XCTAssertNotNil(service)
    }
    
    func test_beacons_default_service_having_no_configuration() {
        //Given sut
        
        //When
        let service = sut.beaconDefaultService()

        XCTAssertNil(service.configuration)
    }
    
    func test_beacons_ktk_service_having_no_configuration() {
        //Given sut
        
        //When
        let service = sut.beaconKontaktService()
        
        XCTAssertNil(service.configuration)
    }
    
    func test_beacon_default_service_overriding_configuration() {
        //Given
        let basicConfiguration = BeaconConfiguration(uuid: "00", identifier: "0")
        let newConfiguration = BeaconConfiguration(uuid: "01", identifier: "1")
        let service = sut.beaconDefaultService(basicConfiguration)
        
        //When
        _ = sut.beaconDefaultService(newConfiguration)
        
        XCTAssertEqual(service.configuration!, newConfiguration)
    }
}

