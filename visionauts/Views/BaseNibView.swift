//
//  BaseNibView.swift
//  visionauts
//
//  Created by Renata Makuch on 19/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit

class BaseNibView: UIView {
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib(){
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        view = (nib.instantiate(withOwner: self, options: nil)[0] as! UIView)
        view.frame = bounds
        setViewApperance()
        addSubview(view)
    }
    
    func setViewApperance() {
    }
    
}
