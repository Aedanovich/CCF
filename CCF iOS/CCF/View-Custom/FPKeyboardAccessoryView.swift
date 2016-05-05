//
//  FPKeyboardAccessoryView.swift
//  Directist
//
//  Created by Alex on 13/11/14.
//  Copyright (c) 2014 Chalkbox Creatives. All rights reserved.
//

import UIKit

typealias DidFinishTyping = (string: String) -> Void

class FPKeyboardAccessoryView: UIView {
    var didFinishTyping: DidFinishTyping!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIButton!

    override func awakeFromNib() {
        let blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = bounds
        effectView.alpha = 0.85
        effectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        insertSubview(effectView, atIndex: 0)
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        if didFinishTyping != nil {
            didFinishTyping(string: textField.text!)
        }
    }
}
