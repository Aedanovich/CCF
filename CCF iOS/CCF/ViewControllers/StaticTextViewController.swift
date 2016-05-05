
//
//  StaticTextViewController.swift
//  CCF
//
//  Created by Alex on 20/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class StaticTextViewController: FPSlidingViewPanelViewController, UITextViewDelegate {
    var data : NSDictionary!
    var section : Section!
    
    @IBOutlet weak var detailsTextView : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsTextView.contentInset = UIEdgeInsetsMake(TOP_COLLECTION_VIEW_XXLONG_INSET, 0.0, 0.0, 0.0)
        detailsTextView.contentOffset = CGPointMake(0.0, -TOP_COLLECTION_VIEW_XXXLONG_INSET)
        self.view.sendSubviewToBack(detailsTextView)
        
        detailsTextView.delegate = self
        
        // Reload
        reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func unloadController() {
        super.unloadController()
    }
    
    func reloadData() {
        if section != nil {
            secondTopBarViewBGImage.clear()
            secondTopBarViewBGImage.setImageWithURL(section.banner, completion: nil)
            secondTopBarViewLabel.text = section.text
        }
    }
}
