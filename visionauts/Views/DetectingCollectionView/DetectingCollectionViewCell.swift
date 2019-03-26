//
//  DetectingCollectionViewCell.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 18/03/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit

class DetectingCollectionViewCell: UICollectionViewCell, NibLoadableView, ReusableCell {

    @IBOutlet weak var titleTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(for itemTitle: String) {
        titleTextView.text = itemTitle
        titleTextView.accessibilityTraits = .none
    }
}
