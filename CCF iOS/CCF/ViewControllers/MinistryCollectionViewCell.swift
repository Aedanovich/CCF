//
//  MinistryCollectionViewCell.swift
//  CCF
//
//  Created by Alex on 19/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class MinistryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var urlImage: FPURLImageView!
    
    func reset() {
        if arc4random() % 2 == 0 {
            titleLabel.textAlignment = .Left
            subtitleLabel.textAlignment = .Right
        }
        else {
            titleLabel.textAlignment = .Right
            subtitleLabel.textAlignment = .Left
        }
        titleLabel.text = ""
        subtitleLabel.text = ""
        urlImage.clear()
    }
}
