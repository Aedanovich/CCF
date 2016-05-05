//
//  FPRateView.swift
//  Directist
//
//  Created by Alex on 7/11/14.
//  Copyright (c) 2014 Chalkbox Creatives. All rights reserved.
//

import UIKit

enum RateViewAlignment : UInt {
    case Left
    case Center
    case Right
}

typealias DidChangeRateValue = (rate: CGFloat)->()

let DefaultFullStarImageFilename : String = "StarFull.png"
let DefaultEmptyStarImageFilename : String = "StarEmpty.png"

class FPRateView: UIView {
    var didChangeRateValue: DidChangeRateValue!
    
    private var _fullStarImage : UIImage? = UIImage(named: DefaultFullStarImageFilename)
    var fullStarImage : UIImage? {
        get {
            return _fullStarImage
        }
        set {
            _fullStarImage = newValue
            self.setNeedsDisplay()
        }
    }
    
    private var _emptyStarImage : UIImage? = UIImage(named: DefaultEmptyStarImageFilename)
    var emptyStarImage : UIImage? {
        get {
            return _emptyStarImage
        }
        set {
            _emptyStarImage = newValue
            self.setNeedsDisplay()
        }
    }
    
    private var _editable : Bool? = false
    var editable : Bool? {
        get { return _editable }
        set {
            _editable = newValue
            userInteractionEnabled = newValue!
        }
    }
    
    var origin : CGPoint = CGPointZero
    var numOfStars : NSInteger = 5
    
    var alignment : RateViewAlignment = RateViewAlignment.Center

    private var _rate : CGFloat? = 0.0
    var rate : CGFloat? {
        get {
            return _rate
        }
        set {
            _rate = newValue
            setNeedsDisplay()
            notifyDelegate()
        }
    }
    var padding : CGFloat = 1
    
    
    override func awakeFromNib() {
        commonSetup()
    }
        
    func commonSetup () {
        padding = 1
        numOfStars = 5
        alignment = RateViewAlignment.Center
        editable = false
    }
    
    override func drawRect(rect: CGRect) {
        switch (alignment) {
        case RateViewAlignment.Left:
            origin = CGPointMake(0, 0)
            break;
        case RateViewAlignment.Center:
            origin = CGPointMake((bounds.size.width - CGFloat(numOfStars) * fullStarImage!.size.width - (CGFloat(numOfStars) - 1) * padding) / 2, 0)
            break;
        case RateViewAlignment.Right:
            origin = CGPointMake(bounds.size.width - CGFloat(numOfStars) * fullStarImage!.size.width - (CGFloat(numOfStars) - 1) * padding, 0);
            break;
        }
        
        
        var x : CGFloat = origin.x
        for _ in 0 ..< numOfStars {
            emptyStarImage?.drawAtPoint(CGPointMake(x, origin.y))
            x += fullStarImage!.size.width + padding
        }
        
        
        let floor : CGFloat = CGFloat(floorf(Float(rate!)))
        x = origin.x
        for _ in 0 ..< Int(floor) {
            fullStarImage?.drawAtPoint(CGPointMake(x, origin.y))
            x += fullStarImage!.size.width + padding
        }
        
        if CGFloat(numOfStars) - floor > 0.01 {
            UIRectClip(CGRectMake(x, origin.y, fullStarImage!.size.width * (rate! - floor), fullStarImage!.size.height))
            fullStarImage?.drawAtPoint(CGPointMake(x, origin.y))
        }
    }
    
    func setAlignment(alignmentValue: RateViewAlignment) {
        alignment = alignmentValue
        self.setNeedsLayout()
    }
    
    
    func handleTouchAtLocation(location: CGPoint) {
        if !editable! {
            return
        }
        for var i = numOfStars - 1; i > -1; i -= 1 {
            if location.x > (origin.x + CGFloat(i) * (fullStarImage!.size.width + padding) - padding / 2) {
                rate = CGFloat(i) + 1
                self.setNeedsDisplay()
                return;
            }
        }
        rate = 0
        self.setNeedsDisplay()
    }
    
//    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        let touch : UITouch = touches.anyObject() as! UITouch
//        let touchLocation = touch.locationInView(self)
//        handleTouchAtLocation(touchLocation)
//    }
//    
//    func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
//        let touch : UITouch = touches.anyObject() as! UITouch
//        let touchLocation = touch.locationInView(self)
//        handleTouchAtLocation(touchLocation)
//    }
    
    func notifyDelegate () {
        if didChangeRateValue != nil {
            didChangeRateValue(rate: rate!)
        }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(rateView:changedToNewRate:)]) {
//    [self.delegate performSelector:@selector(rateView:changedToNewRate:)
//    withObject:self withObject:[NSNumber numberWithFloat:self.rate]];
//    }
    }

}
