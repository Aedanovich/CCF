//
//  FPExpandInputView.swift
//  Directist
//
//  Created by Alex on 11/11/14.
//  Copyright (c) 2014 Chalkbox Creatives. All rights reserved.
//

import UIKit

typealias DidChangeHeight = () -> Void

class FPExpandInputView: UIView {
    var didChangeHeight: DidChangeHeight!
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var placeholderView: UIView!
    @IBOutlet weak var expandIndicator: UIView!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var expandInputView: UIView!
    @IBOutlet weak var totalViewHeight: NSLayoutConstraint!
    @IBOutlet weak var expandInputViewHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        if displayView != nil {
            displayView.layer.shadowRadius = 1.0
            displayView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
            displayView.layer.shadowOpacity = 0.3
            displayView.layer.shadowColor = UIColor.blackColor().CGColor
            displayView.layer.shadowPath = UIBezierPath(rect: displayView.bounds).CGPath
        }
//        if totalViewHeight != nil && displayView != nil {
//            totalViewHeight.constant = displayView.bounds.size.height
//            layoutIfNeeded()
//        }
    }
    
    func showPlaceholder (show: Bool) {
        if placeholderView != nil {
            placeholderView.hidden = !show
        }
    }
    
    func collapse () {
        totalViewHeight.constant = displayView.bounds.size.height
        
        UIView.animateWithDuration(0.3,
            delay: 0.0,
            options: [.AllowAnimatedContent, .AllowUserInteraction, .CurveEaseOut],
            animations: {
                self.expandIndicator.transform = CGAffineTransformIdentity
                self.layoutIfNeeded()
            }, completion: nil)
        
        if didChangeHeight != nil {
            didChangeHeight()
        }
    }

    @IBAction func expandButtonTapped(sender: AnyObject) {
        if totalViewHeight != nil && displayView != nil && expandInputViewHeight != nil {
            let expand = totalViewHeight.constant <= displayView.bounds.size.height
            if expand {
                totalViewHeight.constant = expandInputViewHeight.constant + displayView.bounds.size.height
            }
            else {
                totalViewHeight.constant = displayView.bounds.size.height
            }
            
            UIView.animateWithDuration(0.3,
                delay: 0.0,
                options: [.AllowAnimatedContent, .AllowUserInteraction, .CurveEaseOut],
                animations: {
                    if self.expandIndicator != nil {
                        self.expandIndicator.transform = expand ? CGAffineTransformMakeRotation(CGFloat(M_PI)) : CGAffineTransformIdentity
                    }
                    self.layoutIfNeeded()
                }, completion: nil)
            
            if didChangeHeight != nil {
                didChangeHeight()
            }
        }
    }
}
