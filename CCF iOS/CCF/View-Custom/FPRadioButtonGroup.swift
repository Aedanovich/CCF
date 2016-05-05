//
//  FPRadioButtonGroup.swift
//  Survax
//
//  Created by Alex on 10/12/14.
//  Copyright (c) 2014 Chalkbox Creatives. All rights reserved.
//

import UIKit
typealias DidChangeSelectedItem = (item: String?, index: Int)->()

class FPRadioButtonGroup: UIView {
    var didChangeSelectedItem: DidChangeSelectedItem!
    var currentIndex: Int = NSNotFound
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
                    
                    button.onStateImage = UIImage(named: "icon_check.png")
                    button.offStateImage = UIImage(named: "icon_checkbox.png")

                    buttons.addObject(button)
                    button.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
                    button.addTarget(self,
                        action: #selector(FPRadioButtonGroup.radioButtonTapped(_:)),
                        forControlEvents: UIControlEvents.TouchUpInside)
                }
            }
        }
    }
    
    func radioButtonTapped(sender: AnyObject) {
        selectButton(sender)
    }
    
    func selectButton(sender: AnyObject) {
        let selected = sender as! FPToggleButton
        
        var index = 0
        for button in buttons {
            let toggleButton = button as! FPToggleButton
            toggleButton.on = false
            
            if selected == toggleButton {
                currentIndex = index
            }

            index += 1;
        }
        
        selected.on = true
        
        if didChangeSelectedItem != nil {
            didChangeSelectedItem(item: selected.titleLabel!.text, index: selected.tag)
        }
    }
    
    func setSelectedIndex(index: NSInteger) {
        for button in buttons {
            if button.tag == index {
                radioButtonTapped(button)
                return
            }
        }
    }
}
