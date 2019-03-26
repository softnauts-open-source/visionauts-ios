//
//  MainCoordinator.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 27/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    
    // Child coordinators
    var childCoordinators = [Coordinator]()
    
    // Navigation controller
    var navigationController: UINavigationController
    
    //MARK: - Init
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: - Coordinator actions
    
    func start() {
        let storyboard = UIStoryboard.storyboard(.main)
        let vc: LaunchingViewController = storyboard.instantiateViewController()
        vc.coordinator = self
        
        navigationController.pushViewController(vc, animated: false)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func openPermissions() {
        guard !childCoordinators.contains(where: { $0 is PermissionCoordinator }) else {
            return
        }
        
        let child = PermissionCoordinator(navigationController: navigationController)
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start()
    }
    
    func openDetectingBeacons() {
        let storyboard = UIStoryboard.storyboard(.detection)
        let vc: DetectingViewController = storyboard.instantiateViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
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
