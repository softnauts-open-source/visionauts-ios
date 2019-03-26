//
//  Utils.swift
//  visionauts
//
//  Created by Renata Makuch on 19/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import Foundation
import UIKit
import Pulsator
import AudioToolbox

class Utils {
    static func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func addShadowToView(opacity: Float , radius: CGFloat,width: Int, height: Int) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
    func setupPulseView(with color: UIColor) {
        let pulsator = Pulsator()
        self.layer.superlayer?.insertSublayer(pulsator, below: self.layer)
        pulsator.numPulse = 5
        pulsator.backgroundColor = color.cgColor
        pulsator.radius = self.frame.size.height
        pulsator.position = self.layer.position
        pulsator.start()
    }
}

extension UICollectionView {
    //MARK: Register collection cell
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableCell {
        register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableCell, T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        register(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not deque cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}

extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        return String(prefix(1)).capitalized + dropFirst()
    }
}
