//
//  FPSlidingViewPanelViewController.swift
//  Directist
//
//  Created by Alex on 5/11/14.
//  Copyright (c) 2014 Enovax. All rights reserved.
//

import UIKit

var DEFAULT_TOP_OFFSET : CGFloat = 200.0
var TOP_BAR_HEIGHT : CGFloat = 64.0
var TOP_BAR_HEIGHT_OFFSET : CGFloat = 20.0

var TOP_COLLECTION_VIEW_SHORT_INSET : CGFloat = 64.0
var TOP_COLLECTION_VIEW_LONG_INSET : CGFloat = 90.0
var TOP_COLLECTION_VIEW_XLONG_INSET : CGFloat = 108.0
var TOP_COLLECTION_VIEW_XXLONG_INSET : CGFloat = 200.0
var TOP_COLLECTION_VIEW_XXXLONG_INSET : CGFloat = 280.0
var BOTTOM_COLLECTION_VIEW_INSET : CGFloat = 0.0

class FPSlidingViewPanelViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var loadingView : FPLoadingView!
    @IBOutlet weak var currentInputView : UITextField!
    @IBOutlet weak var keyboardAccessoryView : FPKeyboardAccessoryView!
    
    @IBOutlet weak var topBarTopConstraint : NSLayoutConstraint!
    @IBOutlet weak var topBarView : UIView!
    @IBOutlet weak var topBarCenterView : UIView!
    @IBOutlet weak var topBarRightView : UIView!
    @IBOutlet weak var topBarLeftView : UIView!
    @IBOutlet weak var topBarTitleLabel : UILabel!
    @IBOutlet weak var topBarSubtitleLabel : UILabel!

    @IBOutlet weak var secondTopBarTopConstraint : NSLayoutConstraint!
    @IBOutlet weak var secondTopBarHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var secondTopBarView : UIView!
    @IBOutlet weak var secondTopBarViewBGImage : FPURLImageView!
    @IBOutlet weak var secondTopBarViewLabel : UILabel!

    @IBOutlet weak var backButton : UIButton!
    @IBOutlet weak var optionsLeftButton : UIButton!
    @IBOutlet weak var optionsRightButton : UIButton!

    var slidingViewController : FPSlidingViewController!
    var lastSecondTopBarConstraint : CGFloat = DEFAULT_TOP_OFFSET

    // TextField
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField != keyboardAccessoryView.textField {
            textField.inputAccessoryView = keyboardAccessoryView
            keyboardAccessoryView.textField.keyboardAppearance = textField.keyboardAppearance
            keyboardAccessoryView.textField.keyboardType = textField.keyboardType
            keyboardAccessoryView.textField.placeholder = textField.placeholder
        }

        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField != keyboardAccessoryView.textField {
            currentInputView = textField
        }
        if keyboardAccessoryView != nil {
            keyboardAccessoryView.textField.text = currentInputView.text
            keyboardAccessoryView.textField.becomeFirstResponder()
        }
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == keyboardAccessoryView.textField && currentInputView != nil {
            currentInputView.text = (textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        }
        else if textField == currentInputView {
            keyboardAccessoryView.textField.text = (currentInputView.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if keyboardAccessoryView != nil {
            keyboardAccessoryView.frame = view.bounds
            keyboardAccessoryView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            keyboardAccessoryView.didFinishTyping = { string in
                if self.currentInputView != nil {
                    let currentInputView : UITextField = self.currentInputView as UITextField
                    currentInputView.text = string
                    if currentInputView.isFirstResponder() {
                        currentInputView.resignFirstResponder()
                    }
                    else if self.keyboardAccessoryView.textField.isFirstResponder() {
                        self.keyboardAccessoryView.textField.resignFirstResponder()
                    }
                }
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Shadows
        if topBarView != nil {
            topBarView.layer.shadowRadius = 1.0
            topBarView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
            topBarView.layer.shadowOpacity = 0.3
            topBarView.layer.shadowColor = UIColor.blackColor().CGColor
            topBarView.layer.shadowPath = UIBezierPath(rect: topBarView.bounds).CGPath
        }
        
        if secondTopBarView != nil {
            secondTopBarView.layer.shadowRadius = 1.0
            secondTopBarView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
            secondTopBarView.layer.shadowOpacity = 0.3
            secondTopBarView.layer.shadowColor = UIColor.blackColor().CGColor
            secondTopBarView.layer.shadowPath = UIBezierPath(rect: secondTopBarView.bounds).CGPath
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func unloadController () {
    
    }
    
    func setupUI () {
//        // Appearance
//        UIColor* appTint = [FPThemeManager CurrentThemeTextTint1];
//        [[UINavigationBar appearance] setTintColor:appTint];
//        
//        NSDictionary *barattributes = [NSDictionary dictionaryWithObjectsAndKeys:
//            [UIFont fontWithName:@"Futura-CondensedMedium" size:20.0f], NSFontAttributeName,
//            appTint, NSForegroundColorAttributeName,
//            nil];
//        [[UINavigationBar appearance] setTitleTextAttributes:barattributes];
//        
//        NSDictionary *baritemattributes = [NSDictionary dictionaryWithObjectsAndKeys:
//            [UIFont fontWithName:@"Futura-CondensedMedium" size:16.0f], NSFontAttributeName,
//            appTint, NSForegroundColorAttributeName,
//            nil];
//        [[UIBarButtonItem appearance] setTitleTextAttributes:baritemattributes forState:UIControlStateNormal];
//        
//        [[UINavigationBar appearance] setBackgroundImage:[UIImage themeImageNamed:@"navigation_bar_background.png"]
//            forBarMetrics:UIBarMetricsDefault];
//        
//        // Options Button
//        [self.optionsLeftButton setImage:[UIImage themeImageNamed:@"icon_options.png"] forState:UIControlStateNormal];
//        if ([self.optionsBarButton.customView isKindOfClass:[UIButton class]]) {
//            UIButton* button = (UIButton*)self.optionsBarButton.customView;
//            [button setImage:[UIImage themeImageNamed:@"icon_options.png"] forState:UIControlStateNormal];
//        }
    }
    
    override func loadView() {
        super.loadView()
        self.setupUI()
    }
    
    func barOptionItemTapped (sender : AnyObject) {
    
    }
    
    @IBAction func backButtonTapped (sender : AnyObject!) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func scrollOffsetLimit () -> CGFloat {
        return -TOP_BAR_HEIGHT
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let yOffset = offset.y
        
        // Top Bar
        let yOffsetLimit = self.scrollOffsetLimit()
        let rawTopYOrigin = yOffset - yOffsetLimit
        let maxYOrigin : CGFloat = 0
        let minYOrigin : CGFloat = -self.topBarView.bounds.size.height + TOP_BAR_HEIGHT_OFFSET


        var topYOrigin : CGFloat = -rawTopYOrigin
        topYOrigin = max(topYOrigin, minYOrigin)
        topYOrigin = min(topYOrigin, maxYOrigin)
        
        // Top Bar
        self.topBarTopConstraint.constant = topYOrigin
        
        // View Mode Bar
        var secondTopOffset : CGFloat = 0.0
        if (yOffset + TOP_BAR_HEIGHT) > 0.0 {
            secondTopOffset = -(yOffset + TOP_BAR_HEIGHT)
        }
        if self.secondTopBarTopConstraint != nil {
            self.secondTopBarTopConstraint.constant = secondTopOffset;
        }
        self.view.layoutIfNeeded()
        
        let range = maxYOrigin - minYOrigin
        let maxPercentage : CGFloat = 1.0
        let minPercentage : CGFloat = 0.0
        var percentage : CGFloat = 1 - rawTopYOrigin / range
        percentage = max(percentage, minPercentage)
        percentage = min(percentage, maxPercentage)
        if self.topBarCenterView != nil {
            self.topBarCenterView.transform = CGAffineTransformMakeScale(percentage, percentage)
            self.topBarCenterView.alpha = percentage
        }
        if self.topBarLeftView != nil {
            self.topBarLeftView.transform = CGAffineTransformMakeScale(percentage, percentage)
            self.topBarLeftView.alpha = percentage
        }
        if self.topBarRightView != nil {
            self.topBarRightView.transform = CGAffineTransformMakeScale(percentage, percentage)
            self.topBarRightView.alpha = percentage
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset
        let yOffset = offset.y
        
        let yOffsetLimit = self.scrollOffsetLimit()
        let rawTopYOrigin = yOffset - yOffsetLimit
        let topYOrigin = -rawTopYOrigin
        if (topYOrigin > -self.topBarView.bounds.size.height) && (topYOrigin < 0) {
            scrollView.scrollRectToVisible(CGRectMake(0.0, yOffsetLimit + TOP_BAR_HEIGHT, 1.0, 1.0), animated: true)
        }
    }
    
    func showTopBar (show : Bool) {
        if self.topBarTopConstraint != nil {
            self.topBarTopConstraint.constant = 0.0
        }
        
        let topYOrigin = show ? 0.0 : -self.topBarView.bounds.size.height
        
        UIView.animateWithDuration(0.3,
            delay: 0.0,
            options: UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.CurveEaseOut | UIViewAnimationOptions.AllowAnimatedContent,
            animations: {
                if self.topBarTopConstraint != nil {
                    self.view.layoutIfNeeded()
                }
                else {
                    self.topBarView.frame = CGRectMake(0.0, topYOrigin,
                        self.topBarView.bounds.size.width,
                        self.topBarView.bounds.size.height)
                }
            }, completion:  nil)
    }
    
    // Segue
    func pushControllerWithIdentifier(identifier:NSString) -> UIViewController {
        var vc: UIViewController! = nil
        if navigationController != nil {
            let nc: UINavigationController? = navigationController
            vc = self.storyboard?.instantiateViewControllerWithIdentifier(identifier) as UIViewController
            nc?.pushViewController(vc, animated: true)
        }
        return vc
    }

    func presentControllerWithIdentifier(identifier:NSString) -> UIViewController {
        let vc: UIViewController = self.storyboard?.instantiateViewControllerWithIdentifier(identifier) as UIViewController
        presentViewController(vc,
            animated: true) {
                
        }
        return vc
    }

}
