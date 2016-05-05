//
//  EventCollectionViewCell.swift
//  CCF
//
//  Created by Alex on 24/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

typealias DidTapJoinButton = (cell: EventCollectionViewCell) -> Void

class EventCollectionViewCell: UICollectionViewCell {
    var didTapJoinButton: DidTapJoinButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var verseLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var urlImage: FPURLImageView!
    @IBOutlet weak var formButton: FPToggleButton!
    @IBOutlet weak var formButtonWidth: NSLayoutConstraint!

    func hideFormButton(hide: Bool) {
        formButtonWidth.constant = hide ? 0 : 100
        formButton.hidden = hide
        layoutIfNeeded()
    }
    
    @IBAction func joinButtonTapped(sender: AnyObject) {
        if didTapJoinButton != nil {
            didTapJoinButton(cell: self)
        }
    }
}
