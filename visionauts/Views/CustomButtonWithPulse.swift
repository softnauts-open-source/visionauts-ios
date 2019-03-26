//
//  CustomButtonWithPulse.swift
//  visionauts
//
//  Created by Renata Makuch on 12/03/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit
import Pulsator

class CustomButtonWithPulse: UIButton {

    var pulsator = Pulsator()

    func setupPulse(with color: UIColor) {
        self.layer.superlayer?.insertSublayer(pulsator, below: self.layer)
        pulsator.numPulse = 4
        pulsator.backgroundColor = color.cgColor
        pulsator.radius = self.frame.size.height
        pulsator.position = self.layer.position
        pulsator.start()
    }
}
