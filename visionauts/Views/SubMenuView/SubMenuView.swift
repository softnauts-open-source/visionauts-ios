//
//  SubMenuView.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 19/03/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit

protocol SubMenuDelegate: class {
    func helpButtonDidTap()
    func settingsButtonDidTap()
}

@IBDesignable
class SubMenuView: BaseNibView {

    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    weak var delegate: SubMenuDelegate?
    
    @IBAction func helpButtonTap(_ sender: Any) {
        delegate?.helpButtonDidTap()
    }
    
    @IBAction func settingsButtonTap(_ sender: Any) {
        delegate?.settingsButtonDidTap()
    }
    
    override func setViewApperance() {
        helpButton.accessibilityTraits = UIAccessibilityTraits.button
        helpButton.accessibilityLabel = NSLocalizedString("HelpButtonDescription", comment: "")
        settingsButton.accessibilityTraits = UIAccessibilityTraits.button
        settingsButton.accessibilityLabel = NSLocalizedString("SettingsButtonDescription", comment: "")
    }
}
