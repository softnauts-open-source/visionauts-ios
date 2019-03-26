//
//  CustomNavigationBar.swift
//  visionauts
//
//  Created by Renata Makuch on 19/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit

protocol CustomNavigationBarDelegate: class {
    func leftButtonDidTap()
}

class CustomNavigationBar: BaseNibView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBInspectable var title : String = "" {
        didSet {
            titleLabel.text = title
            titleLabel.accessibilityLabel = title
        }
    }
    
    weak var delegate: CustomNavigationBarDelegate?
    
    override func awakeFromNib() {
        setupAccessibility()
    }
    
    func setupAccessibility() {
        backButton.accessibilityTraits = UIAccessibilityTraits.button
        backButton.accessibilityLabel = NSLocalizedString("BackButtonDescription", comment: "")
    }
    
    @IBAction func backButtonTap(_ sender: Any) {
        delegate?.leftButtonDidTap()
    }
}
