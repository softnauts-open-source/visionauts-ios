//
//  SettingsViewModelTests.swift
//  visionautsTests
//
//  Created by Renata Makuch on 21/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import XCTest
@testable import visionauts

class SettingsServiceTests: XCTestCase {
    
    var sut: SettingsViewModel?
    
    override func setUp() {
        super.setUp()
        sut = SettingsViewModel(SettingsManager.shared)
        
        //RESET User Defaults
        UserDefaults.standard.removeObject(forKey: "bluetoothRange")
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    //MARK: - initialization
    func test_initialization() {
        //Given
        let settingsManager = SettingsManager.shared
        let settingsViewModel = SettingsViewModel(settingsManager)
        
        //When
        XCTAssertNotNil(settingsViewModel, "Settings view model should not be nil.")
        XCTAssertTrue(settingsViewModel.settingsManager === settingsManager, "Manager should be equal to the Settings Manager that was passed in.")
    }
    
    func test_initialization_current_range() {
        //Given
        let sut = self.sut!
        
        //When
        let currentRange = sut.currentRange
        
        XCTAssertEqual(currentRange, 50.0)
    }
    
    //MARK: - get current range
    func test_get_current_range() {
        //Given
        let sut = self.sut!
        
        //When
        let currentRange = sut.getCurrentRange()
        
        XCTAssertNotNil(currentRange)
    }
    
    func test_get_current_range_function() {
        //Given
        let sut = self.sut!
        let _ = sut.saveRange(50.0)
        
        //When
        let currentRange = sut.currentRange
        let rangeFromDefaults = sut.settingsManager.getRange()
        
        XCTAssertEqual(currentRange, rangeFromDefaults)
    }
    
    //MARK: - set current range
    func test_set_current_range_success() {
        //Given
        let sut = self.sut!
        
        //When
        let result = sut.saveRange(50.0)
        
        XCTAssertTrue(result)
    }
    
    func test_set_current_range_false_above_range() {
        //Given
        let sut = self.sut!
        
        //When
        let result = sut.saveRange(150.0)
        
        XCTAssertFalse(result)
    }
    
    func test_set_current_range_false_below_range() {
        //Given
        let sut = self.sut!
        
        //When
        let result = sut.saveRange(-10.0)
        
        XCTAssertFalse(result)
    }
    
    //MARK: - convert
    func test_convert_range_to_string() {
        //Given
        let sut = self.sut!
        
        //When
        let string = sut.getTextFromValue(50.0)
        
        XCTAssertEqual(string, "50")
    }
    
    func test_convert_string_max_range_to_float() {
        //Given
        let sut = self.sut!
        
        //When
        let value = sut.getValueFromText("50")
        
        XCTAssertEqual(value, 50.0)
    }
    
    func test_convert_string_min_range_to_float() {
        //Given
        let sut = self.sut!
        
        //When
        let value = sut.getValueFromText("0.0")
        
        XCTAssertEqual(value, 0.0)
    }
    
    func test_convert_string_no_number_to_float(){
        //Given
        let sut = self.sut!
        
        //When
        let value = sut.getValueFromText("")
        
        XCTAssertEqual(value, 0.0)
    }
    
    //MARK: - VoiceOver status
    func test_get_voice_over_status_true() {
        //Given
        let sut = self.sut!
        let expect = XCTestExpectation(description: "Get status true")
        sut.setVoiceOverStatus = { (color, text) in
            XCTAssertEqual(text, "ON")
            expect.fulfill()
        }
        
        //When
        sut.getVoiceOverStatus(true)
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func test_get_voice_over_status_false() {
        //Given
        let sut = self.sut!
        let expect = XCTestExpectation(description: "Get status false")
        sut.setVoiceOverStatus = { (color, text) in
            XCTAssertEqual(text, "OFF")
            expect.fulfill()
        }
        
        //When
        sut.getVoiceOverStatus(false)
        
        wait(for: [expect], timeout: 1.0)
    }
}
