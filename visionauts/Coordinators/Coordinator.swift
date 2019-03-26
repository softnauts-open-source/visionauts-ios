//
//  Coordinator.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 27/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    func back()
}
