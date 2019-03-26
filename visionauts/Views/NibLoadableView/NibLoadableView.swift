//
//  NibLoadableView.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 18/03/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation
import UIKit

protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}
