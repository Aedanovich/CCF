//
//  FPLoadingView.swift
//  CCF
//
//  Created by Alex on 18/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class FPLoadingView: UIView {
    @IBOutlet var activityIndicatorView : UIActivityIndicatorView!

    override func awakeFromNib() {
        let blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = bounds
        effectView.alpha = 1
        effectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        insertSubview(effectView, atIndex: 0)
    }
    
    func show(show: Bool) {
        if show {
            activityIndicatorView.startAnimating()
            hidden = false
        }
        else {
            activityIndicatorView.stopAnimating()
            hidden = true
        }
    }
}
