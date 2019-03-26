//
//  DetectingViewController.swift
//  visionauts
//
//  Created by Renata Makuch on 19/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit
import CoreLocation

class DetectingViewController: UIViewController {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var mainButton: CustomButtonWithPulse!
    @IBOutlet weak var subMenu: SubMenuView!
    @IBOutlet weak var detectingPlayerView: DetectingCollectionView!
    
    // Main coordinator
    weak var coordinator: MainCoordinator?
    
    // Beacons service
    var beaconService = ServiceFactory.beaconDefaultService()
    
    // Voice synthesizer
    let voiceSynthesizer = ServiceFactory.voiceSynthesizerService
    
    // Detector player view model
    lazy var playerViewModel: DetectingBeaconsViewModel = {
       return DetectingBeaconsViewModel()
    }()

    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        startLocating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        mainButton.pulsator.stop()
    }

    //MARK: - Setup
    
    func setup() {
        subMenu.delegate = self
        setUpAppearance()
        setUpAccessibility()
        setUpBeaconService()
        setUpDetectingPlayer()
        setUpViewModel()
    }
    
    func setUpAppearance() {
        // initial state
        mainButton.setupPulse(with: UIColor.lightRoyalBlue)
        detectingPlayerView.isHidden = true
        mainButton.isHidden = false
        topLabel.isHidden = false
    }
    
    func setUpDetectingPlayer() {
        detectingPlayerView.delegate = self
    }
    
    func setUpBeaconService() {
        let configuration = BeaconConfiguration(uuid: "13e21aa0-9868-49b4-98f2-822c0d4b9ca7", identifier: "Beacon")
        beaconService.configuration = configuration
        beaconService.delegate = self
    }
    
    func setUpAccessibility() {
        mainButton.accessibilityTraits = UIAccessibilityTraits.button
        mainButton.accessibilityLabel = NSLocalizedString("DetectingButtonDescription", comment: "")
    }
    
    //MARK: - Player View Model
    
    func setUpViewModel() {
        playerViewModel.loadItems = { [weak self] (items) in
            guard self != nil else { return }
            guard !items.isEmpty else {
                if self?.mainButton.pulsator.isPulsating == false {
                    self?.mainButton.setupPulse(with: UIColor.lightRoyalBlue)
                }
                self?.detectingPlayerView.isHidden = true
                self?.mainButton.isHidden = false
                self?.topLabel.isHidden = false
                
                return
            }
            
            self?.mainButton.isHidden = true
            self?.topLabel.isHidden = true
            self?.detectingPlayerView.isHidden = false
            
            if self?.mainButton.pulsator.isPulsating == true {
                self?.mainButton.pulsator.stop()
            }
            self?.detectingPlayerView.testItems = items
            self?.detectingPlayerView.collectionView.reloadData()
            self?.detectingPlayerView.collectionView.setContentOffset(CGPoint.zero, animated: false)
            
            if let text = self?.playerViewModel.getCurrentItem()?.descriptionInCurrentLanguage {
                self?.voiceSynthesizer.speak(text)
            }
        }
        
        playerViewModel.showItemAtIndex = { [weak self] (index, position) in
            self?.detectingPlayerView.collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: position, animated: true)
            self?.detectingPlayerView.currentIndex = index
            
            if let text = self?.playerViewModel.getCurrentItem()?.descriptionInCurrentLanguage {
                self?.voiceSynthesizer.speak(text)
            }
        }
        
        playerViewModel.updatePlayerControls = { [weak self] (buttonPreviousVisible, buttonNextVisible) in
            let buttonNext = self?.detectingPlayerView.buttonNext
            let buttonPrevious = self?.detectingPlayerView.buttonPrevious
            
            buttonPrevious?.isUserInteractionEnabled = buttonPreviousVisible
            buttonNext?.isUserInteractionEnabled = buttonNextVisible
            
            buttonPrevious?.layer.opacity = buttonPreviousVisible ? 1 : 0
            buttonNext?.layer.opacity = buttonNextVisible ? 1 : 0
        }
    }
    
    //MARK: - Check Bluetooth permissions
    
    func checkBluetoothPermissions() {
        if !ServiceFactory.bluetoothService.isBluetoothAvailable() {
            coordinator?.openPermissions()
        }
    }
    
    //MARK: - Beacons Monitoring
    
    func startLocating() {
        beaconService.startLocating()
    }
    
    func stopLocating() {
        beaconService.stopLocating()
    }
}

//MARK: - Main Detecting Button Action

extension DetectingViewController {
    
    @IBAction func mainDetectingButtonTap(_ sender: Any) {
        Utils.vibrate()
        
        if !ServiceFactory.permissions.locationIsActive {
            let btAlertText = NSLocalizedString("LocationsPermissionRefusedInfoAlert", comment: "")
            let alert = UIAlertController(title: btAlertText, message: "", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: { (action) in
                
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
            voiceSynthesizer.speak(btAlertText)
        }
    }
}

//MARK: - Detecting Player Delegate

extension DetectingViewController: DetectingPlayerDelegate {
    func playButtonDidTap() {
        if let text = playerViewModel.getCurrentItem()?.descriptionInCurrentLanguage {
            voiceSynthesizer.speak(text)
        }
    }
    
    func nextButtonDidTap() {
        playerViewModel.loadNextItem()
    }
    
    func previousButtonDidTap() {
        playerViewModel.loadPreviousItem()
    }
}

//MARK: - Beacon Service Delegate

extension DetectingViewController: LocationProtocol {
    
    func didChangeAuthorizationStatus(_ status: CLAuthorizationStatus) {
        
        switch status {
            
        case .notDetermined:
            beaconService.locationManager.requestAlwaysAuthorization()
            
        case .denied, .restricted:
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            
        case .authorizedWhenInUse, .authorizedAlways:
            break
        }
    }
    
    func foundBeacons(_ beacons: [CLBeacon]) {
        playerViewModel.load(beacons)
    }
    
    func didStartMonitoringBeacons(in region: CLRegion) {
        
    }
    
    func locationMonitoringDidFail(with error: Error) {
        
    }
}

//MARK: - Sub Menu Delegate

extension DetectingViewController: SubMenuDelegate {
    
    func helpButtonDidTap() {
        coordinator?.openHelpMenu()
    }
    
    func settingsButtonDidTap() {
        coordinator?.openSettingsMenu()
    }
}
