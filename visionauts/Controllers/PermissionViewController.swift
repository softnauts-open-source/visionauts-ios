//
//  PermissionViewController.swift
//  visionauts
//
//  Created by Renata Makuch on 19/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit

class PermissionViewController: UIViewController {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var mainButton: CustomButtonWithPulse!
    @IBOutlet weak var subMenu: SubMenuView!
    
    // Permission coordinator
    weak var coordinator: PermissionCoordinator?
    
    // Bluetooth Service
    var bluetoothManager = ServiceFactory.bluetoothService
    
    // Voice synthesizer
    let voiceSynthesizer = ServiceFactory.voiceSynthesizerService
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainButton.setupPulse(with: UIColor.redPink)
        voiceSynthesizer.speak(NSLocalizedString("BluetoothInfoAlert", comment: ""))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        mainButton.pulsator.stop()
    }

    //MARK: - Setup
    
    func setup() {
        subMenu.delegate = self
        
        // take control over bt manager delegate by self
        bluetoothManager.delegate = self

        setUpAccessibility()
    }
    
    func setUpAccessibility() {
        mainButton.accessibilityTraits = UIAccessibilityTraits.button
        mainButton.accessibilityLabel = NSLocalizedString("PermissionButtonDescription", comment: "")
    }
}

//MARK: - Main Button Action

extension PermissionViewController {
    
    @IBAction func mainButtonTap(_ sender: UIButton) {
        Utils.vibrate()
        
        let btAlertText = NSLocalizedString("BluetoothInfoAlert", comment: "")
        let alert = UIAlertController(title: btAlertText, message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        voiceSynthesizer.speak(btAlertText)
    }
}

//MARK: - Bluetooth service delegate

extension PermissionViewController: BluetoothServiceDelegate {
    func bluetoothStateChange(isEnabled: Bool) {
        ServiceFactory.permissions.bluetoothIsActive = isEnabled
        if isEnabled {
            coordinator?.didFinishPermission()
            
            // restore bt manager delegate control to AppDelegate
            bluetoothManager.delegate = UIApplication.shared.delegate as! AppDelegate
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - Sub Menu Delegate

extension PermissionViewController: SubMenuDelegate {
    func helpButtonDidTap() {
        coordinator?.openHelpMenu()
    }
    
    func settingsButtonDidTap() {
        coordinator?.openSettingsMenu()
    }
}
