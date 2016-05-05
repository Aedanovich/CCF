//
//  FPToggleButton.swift
//  Directist
//
//  Created by Alex on 6/11/14.
//  Copyright (c) 2014 Chalkbox Creatives. All rights reserved.
//

import UIKit

class FPToggleButton: UIButton {
    var offStateBGColor : UIColor!
    var onStateBGColor : UIColor!
    var offStateImage: UIImage!
    var onStateImage: UIImage!
    
    private var _on : Bool = false
    var on: Bool {
        set {
            _on = newValue
            
            if (_on) {
                setImage(onStateImage, forState: UIControlState.Normal)
                if onStateBGColor != nil {
                    setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                    backgroundColor = onStateBGColor
                }
            }
            else {
                setImage(offStateImage, forState: UIControlState.Normal)
                if offStateBGColor != nil {
                    setTitleColor(onStateBGColor, forState: UIControlState.Normal)
                    backgroundColor = offStateBGColor
                }
            }

        }
        get { return _on }
    }

    override func awakeFromNib () {
        super.awakeFromNib()
        
        setupUI()
    }
    
    func setupUI () {
        imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        offStateImage = imageForState(UIControlState.Normal)
        onStateImage = imageForState(UIControlState.Highlighted)
    }
}
