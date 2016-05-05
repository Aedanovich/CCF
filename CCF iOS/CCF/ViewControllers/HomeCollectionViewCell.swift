//
//  HomeCollectionViewCell.swift
//  CCF
//
//  Created by Alex on 17/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleBG: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var urlImage: FPURLImageView!
    @IBOutlet weak var urlImageOverlay: UIView!
    
    func reset() {
        if arc4random() % 2 == 0 {
            titleLabel.textAlignment = .Left
            subtitleLabel.textAlignment = .Right
        }
        else {
            titleLabel.textAlignment = .Right
            subtitleLabel.textAlignment = .Left
        }
        titleBG.hidden = false
        urlImageOverlay.hidden = false
        titleLabel.text = ""
        subtitleLabel.text = ""
        urlImage.image = nil
    }
}
