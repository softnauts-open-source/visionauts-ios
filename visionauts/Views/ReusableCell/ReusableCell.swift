//
//  ReusableCell.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 18/03/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit

public protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

public extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
