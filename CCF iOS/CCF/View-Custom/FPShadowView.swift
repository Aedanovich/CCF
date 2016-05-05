//
//  FPShadowView.swift
//  CCF
//
//  Created by Alex on 18/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class FPShadowView: UIView {
    override func awakeFromNib() {
        layer.shadowRadius = 1.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0);
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowPath = UIBezierPath(rect: bounds).CGPath
    }
}
