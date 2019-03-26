//
//  Storyboarded.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 27/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit

extension UIStoryboard {
    enum Storyboard: String {
        case main
        case helpMenu
        case settingsMenu
        case permissions
        case detection
        
        var fileName: String {
            return rawValue.firstCapitalized
        }
    }
    
    //MARK: - Convenience Init
    
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.fileName, bundle: bundle)
    }
    
    //MARK: - Class Function
    
    class func storyboard(_ storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.fileName, bundle: bundle)
    }
    
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier: \(T.storyboardIdentifier)")
        }
        return viewController
    }
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable {}
