//
//  SettingsViewController.swift
//  visionauts
//
//  Created by Renata Makuch on 19/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, CustomNavigationBarDelegate {

    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var settingsView: SettingsView!
    
    // Coordinator
    weak var coordinator: Coordinator?
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    //MARK: - Setup
    
    func setup() {
        customNavigationBar.delegate = self
    }
    
    //MARK: - Navigation
    
    func leftButtonDidTap() {
        coordinator?.back()
    }
}
