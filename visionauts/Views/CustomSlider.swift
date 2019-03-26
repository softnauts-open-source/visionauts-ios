//
//  CustomSlider.swift
//  visionauts
//
//  Created by Renata Makuch on 20/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation
import UIKit

class CustomSlider: UISlider {
    
    override func awakeFromNib() {
        self.setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        self.maximumValue = 100
        self.minimumValue = 0
        self.minimumTrackTintColor = UIColor(red: 45.0/255.0, green: 76.0/255.0, blue: 251.0/255.0, alpha: 1.0)
        self.maximumTrackTintColor = UIColor(red: 45.0/255.0, green: 76.0/255.0, blue: 251.0/255.0, alpha: 1.0)
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width, height: 2.0))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
}
