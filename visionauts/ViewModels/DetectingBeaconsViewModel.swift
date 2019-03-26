//
//  DetectingBeaconsViewModel.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 18/03/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class DetectingBeaconsViewModel {
    var updatePlayerControls: ((_ previousButtonVisible: Bool, _ nextButtonVisible: Bool) -> Void)?
    var showItemAtIndex: ((_ indexPath: Int, _ position: UICollectionView.ScrollPosition) -> Void)?
    var loadItems: ((_ items: [String]) -> Void)?
    
    // Timer
    var refreshTimer = Timer()
    
    // Current Item index
    var currentItemIndex: Int = 0
    
    // Data
    private var items: [BeaconModel] = [] {
        didSet {
            let testTexts = items.map {
                return $0.descriptionInCurrentLanguage ?? "empty description"
            }
            
            currentItemIndex = 0
            loadItems?(testTexts)
            let controls = setPlayerControlsVisibilty(index: 0, itemsCount: items.count)
            updatePlayerControls?(controls.isLeft, controls.isRight)
        }
    }
    
    //MARK: - Get Item at index
    
    func getCurrentItem() -> BeaconModel? {
        guard !items.isEmpty else { return nil }
        
        return items[currentItemIndex]
    }
    
    //MARK: - Beacons Loading
    
    func load(_ beacons: [CLBeacon]) {
        
        let knownBeacons = ServiceFactory.databaseService.getBeaconsMatching(beacons, form: CoreDataManager.shared.getContext(.main))
        
        guard !knownBeacons.isEmpty else {
            self.items.removeAll()
            return
        }

        refreshTimer.invalidate()
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
            self.currentItemIndex = 0
            self.items.removeAll()
        })
        
        let currentItems: Set<BeaconModel> = Set(items)
        let recognized: Set<BeaconModel> = Set(knownBeacons)
        
        /// debug test
        //        let appearedItems: Set<BeaconModel> = recognized.subtracting(currentItems)
        //        let disappearedItems: Set<BeaconModel> = currentItems.subtracting(recognized)
        
        if currentItems != recognized {
            self.items = knownBeacons
        }
    }
    
    //MARK: - Items Navigation
    
    func loadNextItem() {
        guard currentItemIndex + 1 <= items.count - 1 else {
            return
        }
        
        currentItemIndex += 1
        let controls = setPlayerControlsVisibilty(index: currentItemIndex, itemsCount: items.count)
        
        guard currentItemIndex < items.count - 1 else {
            updatePlayerControls?(controls.isLeft, controls.isRight)
            showItemAtIndex?(currentItemIndex, .right)
            return
        }
        
        updatePlayerControls?(controls.isLeft, controls.isRight)
        showItemAtIndex?(currentItemIndex, .right)
    }
    
    func loadPreviousItem() {
        guard currentItemIndex - 1 >= 0 else {
            return
        }
        
        currentItemIndex -= 1
        let controls = setPlayerControlsVisibilty(index: currentItemIndex, itemsCount: items.count)
        
        guard currentItemIndex > 0 else {
            updatePlayerControls?(controls.isLeft, controls.isRight)
            showItemAtIndex?(currentItemIndex, .left)
            return
        }
        
        updatePlayerControls?(controls.isLeft, controls.isRight)
        showItemAtIndex?(currentItemIndex, .left)
    }
    
    //MARK: - Player Controls Visibility
    
    private func setPlayerControlsVisibilty(index: Int, itemsCount: Int) -> (isLeft: Bool, isRight: Bool) {
        var isLeftVisible = false
        var isRightVisible = false

        if index == 0 {
            
            if itemsCount == 0 {
                isLeftVisible = false
                isRightVisible = false
                
            } else if itemsCount == 1 {
                isLeftVisible = false
                isRightVisible = false
                
            } else if itemsCount > 1 {
                isLeftVisible = false
                isRightVisible = true
            }
            
        } else if index > 0 && index < itemsCount - 1 {
            isLeftVisible = true
            isRightVisible = true
            
        } else if index == itemsCount - 1 {
            isLeftVisible = true
            isRightVisible = false
        }
        
        return (isLeftVisible, isRightVisible)
    }
}

