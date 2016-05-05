//
//  FPBlurView.swift
//  Survax
//
//  Created by Alex on 3/12/14.
//  Copyright (c) 2014 Chalkbox Creatives. All rights reserved.
//

import UIKit

class FPBlurView: UIView {

    override func awakeFromNib() {
        if NSClassFromString("UIBlurEffect") != nil {
            let blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
            effectView.frame = bounds
            effectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
            effectView.alpha = 0.95
            insertSubview(effectView, atIndex: 0)
        }
        else {
            backgroundColor = UIColor(white: 0, alpha: 0.8)
        }
    }

}
