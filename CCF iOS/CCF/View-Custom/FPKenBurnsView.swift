//
//  FPKenBurnsView.swift
//  CCF
//
//  Created by Alex on 20/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

let KenBurnsAnimationDuration = 5.0

class FPKenBurnsView: UIView {
    @IBOutlet weak var imageView: FPURLImageView!
    
    var imageURL: String? {
        get {
            return imageView.currentURL
        }
        set (newImage) {
            imageView.setImageWithURL(newImage!, completion:nil)
        }
    }
    
    func animate() {
        UIView.animateWithDuration(KenBurnsAnimationDuration,
            delay: 0.0,
            options: [.AllowUserInteraction, .CurveEaseInOut],
            animations: {
                if let imageView = self.imageView {
                    let width: CGFloat = imageView.bounds.size.width
                    let height: CGFloat = imageView.bounds.size.height
                    let widthArea: UInt32 = UInt32(imageView.bounds.size.width) - UInt32(width)
                    let heightArea: UInt32 = UInt32(imageView.bounds.size.height) - UInt32(height)
                    imageView.frame = CGRectMake(CGFloat(arc4random() % widthArea),
                        CGFloat(arc4random() % heightArea),
                        width, height)
                }
            }, completion: { finished in
                if finished {
                    self.animate()
                }
        })
    }
}
