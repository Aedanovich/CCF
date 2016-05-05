//
//  FPPreviewBarView.swift
//  CCF
//
//  Created by Alex on 19/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class FPPreviewBarView: UIView {
    var enableExpand: Bool = true
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var previewImageView: FPURLImageView!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var previewSubLabel: UILabel!
    @IBOutlet weak var previewVideoView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func awakeFromNib() {
        let blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let effectView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        effectView.frame = bounds
        effectView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        insertSubview(effectView, atIndex: 0)
    }
}
