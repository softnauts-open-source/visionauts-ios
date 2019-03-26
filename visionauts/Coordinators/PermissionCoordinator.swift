//
//  PermissionCoordinator.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 11/03/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit

class PermissionCoordinator: Coordinator {
    
    // Child coordinators
    var childCoordinators = [Coordinator]()
    
    // Navigation controller
    var navigationController: UINavigationController
    
    // Parent coordinator
    weak var parentCoordinator: MainCoordinator?
    
    //MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: - Coordinator actions
    
    func start() {
        let storyboard = UIStoryboard.storyboard(.permissions)
        let permVC: PermissionViewController = storyboard.instantiateViewController()
        permVC.coordinator = self
        let root = UINavigationController(rootViewController: permVC)
        root.setNavigationBarHidden(true, animated: false)
        
        navigationController.present(root, animated: true) { [weak self] in
            // override navigation controller with new one for permissions
            // after presentation of permission controller
            self?.navigationController = root
        }
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
    func didFinishPermission() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func openSettingsMenu() {
        let storyboard = UIStoryboard.storyboard(.settingsMenu)
        let vc: SettingsViewController = storyboard.instantiateViewController()
        vc.coordinator = self
    
        navigationController.pushViewController(vc, animated: true)
    }
    
    func openHelpMenu() {
        let storyboard = UIStoryboard.storyboard(.helpMenu)
        let vc: HelpViewController = storyboard.instantiateViewController()
        vc.coordinator = self
        
        navigationController.pushViewController(vc, animated: true)
    }
}
