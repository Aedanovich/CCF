//
//  FPShadowButton.swift
//  SentosaPOS
//
//  Created by Alex on 6/1/15.
//  Copyright (c) 2015 Chalkbox Creatives. All rights reserved.
//

import UIKit

class FPShadowButton: UIButton {
    override func awakeFromNib() {
        refreshShadow()
    }
    
    func refreshShadow() {
        layer.shadowRadius = 3.0
        layer.shadowOffset = CGSizeMake(2, 2);
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.blackColor().CGColor
        if layer.cornerRadius > 0 {
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).CGPath
        }
        else {
            layer.shadowPath = UIBezierPath(rect: bounds).CGPath
        }
    }
}
