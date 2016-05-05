//
//  FPWideScrollView.swift
//  SentosaPOS
//
//  Created by Alex on 6/1/15.
//  Copyright (c) 2015 Chalkbox Creatives. All rights reserved.
//

import UIKit

class FPWideScrollView: UIView {
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if pointInside(point, withEvent: event) {
            if subviews.count > 0 {
                return subviews.first
            }
            else {
                return self
            }
        }
        return nil
    }
}
