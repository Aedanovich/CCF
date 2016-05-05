//
//  FPSegmentControl.swift
//  Directist
//
//  Created by Alex on 6/11/14.
//  Copyright (c) 2014 Chalkbox Creatives. All rights reserved.
//

import UIKit

typealias DidSelectIndex = (index: Int)->()

class FPSegmentControl: UIView {
    var didSelectIndex : DidSelectIndex!
    @IBOutlet weak var centerView : UIView!
    @IBOutlet weak var indicator : UIView!
    @IBOutlet weak var indicatorWidthConstraint : NSLayoutConstraint!
    @IBOutlet weak var indicatorLeftConstraint : NSLayoutConstraint!
    @IBOutlet weak var indicatorRightConstraint : NSLayoutConstraint!
    var buttons : NSMutableArray = NSMutableArray(capacity: 0)

    override func awakeFromNib () {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI () {
        if !self.subviews.isEmpty {
            for view in self.subviews {
                if view.isKindOfClass(FPToggleButton) {
                    let button = view as! FPToggleButton
                    
                    buttons.addObject(button)
                    button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
                    button.addTarget(self,
                        action: #selector(FPSegmentControl.segmentTapped(_:)),
                        forControlEvents: UIControlEvents.TouchUpInside)
                }
            }
        }
    }
    
    func segmentTapped(sender: AnyObject) {
        animateIndicatorToButton(sender)
    }
    
    func animateIndicatorToButton(sender: AnyObject) {
        let selected = sender as! FPToggleButton

        for button in buttons {
            let toggleButton = button as! FPToggleButton
            toggleButton.on = false
        }
        
        selected.on = true
        
        if didSelectIndex != nil {
            didSelectIndex(index: selected.tag)
        }
        
        if indicatorLeftConstraint != nil && indicatorWidthConstraint != nil {
            if indicatorLeftConstraint != nil {
                self.indicator.removeConstraint(indicatorLeftConstraint)
            }
            if indicatorRightConstraint != nil {
                self.indicator.removeConstraint(indicatorRightConstraint)
            }

            indicatorLeftConstraint = NSLayoutConstraint(item: indicator,
                attribute: NSLayoutAttribute.Leading,
                relatedBy: NSLayoutRelation.Equal,
                toItem: (selected.tag == 0) ? centerView : indicator.superview,
                attribute: NSLayoutAttribute.Left,
                multiplier: 1.0,
                constant: 2.0)
            indicatorRightConstraint = NSLayoutConstraint(item: indicator,
                attribute: NSLayoutAttribute.Leading,
                relatedBy: NSLayoutRelation.Equal,
                toItem: (selected.tag == 0) ? indicator.superview : centerView,
                attribute: NSLayoutAttribute.Right,
                multiplier: 1.0,
                constant: 2.0)
            
            indicator.addConstraints([indicatorLeftConstraint, indicatorRightConstraint])

            UIView.animateWithDuration(0.1,
                delay: 0.0,
                options: [UIViewAnimationOptions.AllowUserInteraction, UIViewAnimationOptions.BeginFromCurrentState],
                animations: {
                    self.layoutIfNeeded()
                }, completion:  nil)
        }
        else {
            UIView.animateWithDuration(0.1,
                delay: 0.0,
                options: [UIViewAnimationOptions.AllowUserInteraction, UIViewAnimationOptions.BeginFromCurrentState],
                animations: {
                    self.indicator.frame = CGRectInset(selected.frame, 2.0, 2.0)
                }, completion:  nil)
        }
    }
    
    func setSelectedIndex(index: NSInteger) {
        for button in buttons {
            if button.tag == index {
                segmentTapped(button)
                return
            }
        }
    }
}
