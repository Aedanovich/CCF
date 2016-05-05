//
//  MinistryDetailViewController.swift
//  CCF
//
//  Created by Alex on 19/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit
import MessageUI

class MinistryDetailViewController: FPSlidingViewPanelViewController, MFMailComposeViewControllerDelegate, UITextViewDelegate {
    var data : Ministry!
    @IBOutlet weak var imageView : FPURLImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var verseTextView : UILabel!
    @IBOutlet weak var detailsTextView : UITextView!
    @IBOutlet weak var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinButton.layer.cornerRadius = 4.0
        joinButton.layer.masksToBounds = true
        
        detailsTextView.contentInset = UIEdgeInsetsMake(TOP_COLLECTION_VIEW_XXLONG_INSET, 0.0, 0.0, 0.0)
        detailsTextView.contentOffset = CGPointMake(0.0, -TOP_COLLECTION_VIEW_XXLONG_INSET)
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
        let name = data.name
        let image = data.image
        let verse = data.verse
        let details = data.details
        
        nameLabel.text = name
        verseTextView.text = verse
        detailsTextView.text = details
        imageView.clear()
        imageView.setImageWithURL(image!, completion: nil)
    }
    
    @IBAction func joinButtonTapped(sender: AnyObject) {
        if let _ = sender as? UIButton {
            let emailTitle = "Inquiry for " + data.name! as String + " Ministry"
            let messageBody = "Hi,\n\n[Please introduce yourself here]\n\nRegards,\n\n[Your Name]"
            let recipient: String? = data.email
            
            let mc: MFMailComposeViewController = MFMailComposeViewController()
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            mc.setMessageBody(messageBody, isHTML: false)
            mc.setToRecipients([recipient!])
            
            self.presentViewController(mc, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            NSLog("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            NSLog("Mail saved")
        case MFMailComposeResultSent.rawValue:
            NSLog("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            NSLog("Mail sent failure: %@", [error!.localizedDescription])
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
