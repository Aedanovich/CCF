
//
//  MessageCollectionViewCell.swift
//  CCF
//
//  Created by Alex on 17/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var videoThumbnailView: FPURLImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        drawShadows()
    }
    
    func drawShadows() {
        videoThumbnailView.superview?.layer.shadowRadius = 1.0
        videoThumbnailView.superview?.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        videoThumbnailView.superview?.layer.shadowOpacity = 0.3
        videoThumbnailView.superview?.layer.shadowColor = UIColor.blackColor().CGColor
        videoThumbnailView.superview?.layer.shadowPath = UIBezierPath(rect: videoThumbnailView.superview!.bounds).CGPath
    }
}
