//
//  FPSlidingViewController.swift
//  Directist
//
//  Created by Alex on 5/11/14.
//  Copyright (c) 2014 Enovax. All rights reserved.
//

import UIKit

var FP_SLIDING_VIEW_SEGUE_MASTER : String =  "fp_master"
var FP_SLIDING_VIEW_SEGUE_MASTER_RIGHT : String =  "fp_master_right"
var FP_SLIDING_VIEW_SEGUE_DETAIL : String =  "fp_detail"

var CORNER_RADIUS : CGFloat = 0.0
var MASTER_OVERLAP : CGFloat = 0.0
var SHADOW_WIDTH : CGFloat = 0.0
var SNAP_DURATION : NSTimeInterval = 0.2

typealias WillHideMasterView = () -> ()
typealias WillShowMasterView = () -> ()

class FPSlidingViewControllerSegue : UIStoryboardSegue, UIGestureRecognizerDelegate {
    override func perform() {
        var src : UIViewController = self.sourceViewController as UIViewController
        var dst : UIViewController = self.destinationViewController as UIViewController
        
        if (src.isKindOfClass(FPSlidingViewController)) {
            var srcSVC : FPSlidingViewController = src as FPSlidingViewController
            if self.identifier!.rangeOfString(FP_SLIDING_VIEW_SEGUE_MASTER)?.startIndex != nil {
                srcSVC.setMasterViewController(self.destinationViewController as UIViewController)
            }
            if self.identifier!.rangeOfString(FP_SLIDING_VIEW_SEGUE_DETAIL)?.startIndex != nil {
                srcSVC.setDetailsViewController(self.destinationViewController as UIViewController)
            }
            
            if dst.isKindOfClass(FPSlidingViewController) {
                let dstSVC = dst as FPSlidingViewController
                dstSVC.parentSlidingViewController = srcSVC
                srcSVC.childSlidingViewController = dstSVC
            }
            
            if dst.isKindOfClass(FPSlidingViewPanelViewController) {
                let dstSVC = dst as FPSlidingViewPanelViewController
                dstSVC.slidingViewController = srcSVC;
            }
        }
    }
}

class FPSlidingViewController: UIViewController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    var willHideMasterView: WillHideMasterView = { }
    var willShowMasterView: WillShowMasterView = { }

    @IBOutlet weak var parentSlidingViewController : FPSlidingViewController!
    @IBOutlet weak var childSlidingViewController  : FPSlidingViewController!
    
    @IBOutlet weak var detailsController : UIViewController!
    @IBOutlet weak var masterController : UIViewController!
    @IBOutlet weak var masterRightController : UIViewController!
    
    @IBOutlet weak var panelViewLeftConstraint : NSLayoutConstraint!
    @IBOutlet weak var panelViewRightConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var panelView : UIView!
    @IBOutlet weak var detailsView : UIView!
    @IBOutlet weak var masterView : UIView!
    @IBOutlet weak var masterRightView : UIView!
    
    var panelPanGestureRecognizer   : UIPanGestureRecognizer!
    var slidingEnabled : Bool = true

    var refreshOrigin : Bool = false
    var leftMasterVisible : Bool = false
    var rightMasterVisible : Bool = false
    var maxXOrigin : CGFloat = 0.0
    var minXOrigin : CGFloat = 0.0
    var originalPoint : CGPoint = CGPointZero
    var parentOriginalPointOffset : CGPoint = CGPointZero
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if masterView != nil {
//            view.bringSubviewToFront(masterView)
//        }
        if masterRightView != nil {
            view.bringSubviewToFront(masterRightView)
        }
        if panelView != nil {
            view.bringSubviewToFront(panelView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func unloadController () {
        self.unloadController(self.masterController)
        self.unloadController(self.detailsController)
    }
    
    func unloadController (controller : UIViewController) {
        if controller.isKindOfClass(UINavigationController) {
            var nc : UINavigationController = controller as UINavigationController
            for vc in nc.viewControllers {
                if vc.respondsToSelector(Selector(unloadController())) {
                    vc.unloadController()
                }
            }
        }
        else if controller.isKindOfClass(FPSlidingViewController) {
            var vc : FPSlidingViewController = controller as FPSlidingViewController
            vc.unloadController(self.detailsController)
            vc.unloadController(self.masterController)
        }
        else {
            if controller.respondsToSelector(Selector(unloadController())) {
//                controller.unloadController()
            }
        }
    }
    
    func setupUI () {
//    // Appearance
//    var appTint : UIColor = [FPThemeManager CurrentThemeTextTint1];
//    [[UINavigationBar appearance] setTintColor:appTint];
//    
//    NSDictionary *barattributes = [NSDictionary dictionaryWithObjectsAndKeys:
//    [UIFont fontWithName:@"Futura-CondensedMedium" size:20.0f], NSFontAttributeName,
//    appTint, NSForegroundColorAttributeName,
//    nil];
//    [[UINavigationBar appearance] setTitleTextAttributes:barattributes];
//    
//    NSDictionary *baritemattributes = [NSDictionary dictionaryWithObjectsAndKeys:
//    [UIFont fontWithName:@"Futura-CondensedMedium" size:16.0f], NSFontAttributeName,
//    appTint, NSForegroundColorAttributeName,
//    nil];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:baritemattributes forState:UIControlStateNormal];
//    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage themeImageNamed:@"navigation_bar_background.png"]
//    forBarMetrics:UIBarMetricsDefault];
//    
//    // Master Controller
//    if ([self.masterController isKindOfClass:[UINavigationController class]]) {
//    NSArray* vcs = [(UINavigationController*)self.masterController viewControllers];
//    for (UIViewController* vc in vcs) {
//    if ([vc respondsToSelector:@selector(setupUI)]) {
//    [vc performSelector:@selector(setupUI)];
//    }
//    }
//    }
//    else {
//    if ([self.masterController respondsToSelector:@selector(setupUI)]) {
//    [self.masterController performSelector:@selector(setupUI)];
//    }
//    
//    }
//    // Details Controller
//    if ([self.detailsController isKindOfClass:[UINavigationController class]]) {
//    NSArray* vcs = [(UINavigationController*)self.detailsController viewControllers];
//    for (UIViewController* vc in vcs) {
//    if ([vc respondsToSelector:@selector(setupUI)]) {
//    [vc performSelector:@selector(setupUI)];
//    }
//    }
//    }
//    else {
//    if ([self.detailsController respondsToSelector:@selector(setupUI)]) {
//    [self.detailsController performSelector:@selector(setupUI)];
//    }
//    }
    }
    
    override func loadView() {
        super.loadView()
    
        self.slidingEnabled = true
        self.masterRightView.hidden = true
    
        if CORNER_RADIUS > 0.0 {
            self.masterView.layer.cornerRadius = CORNER_RADIUS
            self.masterView.layer.masksToBounds = true
            self.detailsView.layer.cornerRadius = CORNER_RADIUS
            self.detailsView.layer.masksToBounds = true
        }
    
        if self.detailsView.subviews.count == 0 {
            self.panelView.frame = CGRectMake(self.view.frame.size.width,
                self.panelView.frame.origin.y,
                self.panelView.frame.size.width,
                self.panelView.frame.size.height)
        }
        
        self.addDragGesture()
        self.addDoubleTapGesture()
    }
    
    override func didMoveToParentViewController(parent: UIViewController?) {
        super.didMoveToParentViewController(parent)
    
        // Details Controller
        if self.detailsController.isKindOfClass(UINavigationController) {
            let nc = self.detailsController as UINavigationController
            let vcs = nc.viewControllers as NSArray
            for vc in vcs {
                vc.didMoveToParentViewController(vc.parentViewController)
            }
        }
        else {
            self.detailsController.didMoveToParentViewController(self.detailsController.parentViewController)
        }
    
        // Master Controller
        if self.masterController.isKindOfClass(UINavigationController) {
            let nc = self.masterController as UINavigationController
            let vcs = nc.viewControllers as NSArray
            for vc in vcs {
                vc.didMoveToParentViewController(vc.parentViewController)
            }
        }
        else {
            self.masterController.didMoveToParentViewController(self.masterController.parentViewController)
        }
    }
    
    func addDoubleTapGesture () {
        let gesture = UITapGestureRecognizer(target: self, action: Selector("didDoubleTapView:"))
        gesture.numberOfTapsRequired = 2
        self.panelView.addGestureRecognizer(gesture)
    }
    
    func didDoubleTapView (tapGestureRecognizer : UITapGestureRecognizer) {
        self.handleDoubleTap(tapGestureRecognizer.state);
    }
    
    func handleDoubleTap (state : UIGestureRecognizerState) {
        if state == UIGestureRecognizerState.Ended {
            self.hideMasterView()
        }
    }
    
    func addDragGesture () {
        self.panelPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("didPanView:"))
        self.panelPanGestureRecognizer.delegate = self
        self.panelView.addGestureRecognizer (self.panelPanGestureRecognizer)
    }
    
    func didPanView (panGestureRecognizer: UIPanGestureRecognizer) {
        self.handlePan(panGestureRecognizer.state,
            deltaPoint: panGestureRecognizer.translationInView(panGestureRecognizer.view!.superview!),
            velocity: panGestureRecognizer.velocityInView(panGestureRecognizer.view?.superview).x,
            shouldMove: true)
    }
    
    func handlePan (state : UIGestureRecognizerState,  deltaPoint : CGPoint,  velocity : CGFloat, shouldMove : Bool) {
        if !self.slidingEnabled {
            return;
        }
        
        var shouldMoveParent : Bool = false
        var parentVelocity : CGFloat = velocity
        
        if state == UIGestureRecognizerState.Began {
            self.startPanning()
            
            self.refreshOrigin = true
            
            self.leftMasterVisible = false
            self.rightMasterVisible = false
            
            if self.panelView.frame.origin.x > self.masterView.frame.origin.x {
                self.leftMasterVisible = true
            }

            if (self.panelView.frame.origin.x + self.panelView.frame.size.width) <= self.masterRightView.frame.origin.x {
                self.rightMasterVisible = true
            }
            
            self.originalPoint = self.panelView.center
            self.parentOriginalPointOffset = CGPointZero
        }
        else if state == UIGestureRecognizerState.Changed {
            self.pan()
            
            if self.panelView.frame.origin.x + self.panelView.frame.size.width < self.masterRightView.frame.origin.x + self.masterRightView.frame.size.width {
                self.masterRightView.hidden = false
            }
            else {
                self.masterRightView.hidden = true
            }
            
            if self.refreshOrigin {
                self.refreshOrigin = false
                
                if self.leftMasterVisible {
                    self.minXOrigin = self.masterView.frame.origin.x
                    self.maxXOrigin = (self.masterView.frame.origin.x + self.masterView.frame.size.width) - MASTER_OVERLAP
                }
                else if self.rightMasterVisible {
                    self.minXOrigin = self.masterView.frame.origin.x - self.masterRightView.bounds.size.width
                    self.maxXOrigin = self.masterView.frame.origin.x
                }
                else {
                    if self.masterRightView != nil {
                        self.minXOrigin = self.masterView.frame.origin.x - self.masterRightView.bounds.size.width
                    }
                    else {
                        self.minXOrigin = self.view.bounds.size.width - self.panelView.frame.size.width
                    }
                    self.maxXOrigin = (self.masterView.frame.origin.x + self.masterView.frame.size.width) - MASTER_OVERLAP
                }
            }
            
            var xOrigin : CGFloat = self.originalPoint.x + deltaPoint.x - (self.panelView.frame.size.width / 2.0)
            let maxXOrigin = self.maxXOrigin
            let minXOrigin = self.minXOrigin
            
            if xOrigin < minXOrigin {
                let difference = xOrigin - minXOrigin
                xOrigin = minXOrigin + (difference / 8.0)
                shouldMoveParent = true
            }
            if xOrigin > maxXOrigin {
                let difference = xOrigin - maxXOrigin
                xOrigin = maxXOrigin + (difference / 8.0)
                shouldMoveParent = true
            }
            
            if (shouldMove) {
                if (self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil) {
                    self.panelViewRightConstraint.constant = -xOrigin
                    self.panelViewLeftConstraint.constant = xOrigin
                    self.view.layoutIfNeeded()
                }
                else {
                    self.panelView.frame = CGRectMake(xOrigin,
                        self.panelView.frame.origin.y,
                        self.panelView.frame.size.width,
                        self.panelView.frame.size.height)
                }
            }
        }
        else if state == UIGestureRecognizerState.Ended {
            self.endPanning()
            
            shouldMoveParent = true;
            
            var xOrigin : CGFloat = self.originalPoint.x + deltaPoint.x - (self.panelView.frame.size.width / 2.0)
            if (xOrigin >= self.masterView.frame.origin.x) {
                parentVelocity = 0.0
            }
            
            var snapXOrigin : CGFloat = 0
            
            if velocity < 0.0 {
                if (self.leftMasterVisible) {
                    if self.willHideMasterView != nil && self.detailsController != nil {
                        self.willHideMasterView()
                    }
                    snapXOrigin = self.masterView.frame.origin.x;
                    let minXOrigin = self.view.bounds.size.width - self.panelView.bounds.size.width;
                    if snapXOrigin < minXOrigin {
                        snapXOrigin = minXOrigin
                    }
                }
                else if self.masterRightView != nil && (xOrigin <= self.masterView.frame.origin.x) {
                    snapXOrigin = self.masterRightView.frame.origin.x - self.panelView.bounds.size.width
                }
                else {
                    snapXOrigin = self.masterView.frame.origin.x
                    
                    let minXOrigin = self.view.bounds.size.width - self.panelView.bounds.size.width
                    if snapXOrigin < minXOrigin {
                        snapXOrigin = minXOrigin
                    }
                }
            }
            else {
                if self.rightMasterVisible {
                    snapXOrigin = self.masterView.frame.origin.x
                }
                else if xOrigin <= self.masterView.frame.origin.x {
                    snapXOrigin = self.masterView.frame.origin.x
                }
                else {
                    if self.willShowMasterView != nil {
                        self.willShowMasterView()
                    }
                    snapXOrigin = self.masterView.frame.origin.x + self.masterView.frame.size.width - MASTER_OVERLAP
                }
            }
            
            snapXOrigin -= SHADOW_WIDTH
            
            if (shouldMove) {
                if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil {
                    self.panelViewRightConstraint.constant = -snapXOrigin
                    self.panelViewLeftConstraint.constant = snapXOrigin
                }
                UIView.animateWithDuration(SNAP_DURATION,
                    delay: 0.0,
                    options: UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.CurveEaseOut | UIViewAnimationOptions.AllowAnimatedContent,
                    animations: {
                        if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil {
                            self.view.layoutIfNeeded()
                        }
                        else {
                            self.panelView.frame = CGRectMake(snapXOrigin,
                                self.panelView.frame.origin.y,
                                self.panelView.frame.size.width,
                                self.panelView.frame.size.height)
                        }

                }, completion:  nil)
            }
            
            self.originalPoint = CGPointZero
        }
        
        if shouldMoveParent {
            if CGPointEqualToPoint(self.parentOriginalPointOffset, CGPointZero) {
                self.parentOriginalPointOffset = deltaPoint
            }
        }
        else {
            self.parentOriginalPointOffset = CGPointZero
        }
        
        if self.parentSlidingViewController != nil {
            let x = deltaPoint.x - self.parentOriginalPointOffset.x
            let y = deltaPoint.y - self.parentOriginalPointOffset.y
            let parentDeltaPoint = CGPointMake(x, y)
            self.parentSlidingViewController?.handlePan(state,
                deltaPoint: parentDeltaPoint,
                velocity: parentVelocity,
                shouldMove: shouldMoveParent)
        }
    }
    
    func startPanning () {
//        // Master Controller
//        if self.masterController.isKindOfClass(UINavigationController) {
//            let nc = self.masterController as UINavigationController
//            let vcs = nc.viewControllers
//            for vc in vcs {
//                if vc.respondsToSelector(Selector("slidingViewControllerDidStartPanning:")) {
//                    vc.slidingViewControllerDidStartPanning(self)
//                }
//            }
//        }
//        else {
//            if self.masterController.respondsToSelector(Selector("slidingViewControllerDidStartPanning:")) {
//                self.masterController.slidingViewControllerDidStartPanning(self)
//            }
//        }
//        // Details Controller
//        if self.detailsController.isKindOfClass(UINavigationController) {
//            let nc = self.detailsController as UINavigationController
//            let vcs = nc.viewControllers
//            for vc in vcs {
//                if vc.respondsToSelector(Selector("slidingViewControllerDidStartPanning:")) {
//                    vc.slidingViewControllerDidStartPanning(self)
//                }
//            }
//        }
//        else {
//            if self.detailsController.respondsToSelector(Selector("slidingViewControllerDidStartPanning:")) {
//                self.detailsController.slidingViewControllerDidStartPanning(self)
//            }
//        }
    }
    
    func pan () {
    
    }
    
    func endPanning () {
    
    }
    
    @IBAction func optionsButtonTapped (sender : NSObject) {
        var fpsvc : FPSlidingViewController = self.parentSlidingViewController != nil ? self.parentSlidingViewController : self
        if (fpsvc.panelView.frame.origin.x <= fpsvc.masterView.frame.origin.x) {
            fpsvc.showMasterView()
        }
        else {
            fpsvc.hideMasterView()
        }
    }
    
    @IBAction func optionsRightButtonTapped (sender : NSObject) {
        var fpsvc : FPSlidingViewController = self.parentSlidingViewController != nil ? self.parentSlidingViewController : self;
        if (fpsvc.panelView.frame.origin.x + fpsvc.panelView.frame.size.width <= fpsvc.masterRightView.frame.origin.x) {
            fpsvc.hideMasterRightView()
        }
        else {
            fpsvc.showMasterRightView()
        }
    }
    
    @IBAction func backButtonTapped (sender : NSObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setSlidingOn (on : Bool) {
        slidingEnabled = on;
    }
    
    func setSlidingEnabled (enabled : Bool) {
        slidingEnabled = enabled;
    
        if (!slidingEnabled) {
            self.hideMasterView();
        }
    }
    
    func replaceDetailView (view : UIView) {
        self.snapOutDetailView(true,
            completionHandler: {
                for view in self.detailsView.subviews {
                    view.removeFromSuperview()
                }
                let frame = self.detailsView.bounds
                view.frame = frame
                self.detailsView.insertSubview(view, atIndex: 0)
                
                self.panelView.hidden = false
                
                var xOrigin : CGFloat = 0.0
                
                let minXOrigin = self.view.bounds.size.width - self.panelView.bounds.size.width
                if (xOrigin < minXOrigin) {
                    xOrigin = minXOrigin;
                }
                
                xOrigin -= SHADOW_WIDTH;
                
                self.parentSlidingViewController.hideMasterView()
                
                if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil {
                    self.panelViewRightConstraint.constant = -xOrigin
                    self.panelViewLeftConstraint.constant = xOrigin
                }
                
                UIView.animateWithDuration(SNAP_DURATION,
                    delay: 0.0,
                    options: UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.CurveEaseOut | UIViewAnimationOptions.AllowAnimatedContent,
                    animations: {
                        if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil {
                            self.view.layoutIfNeeded()
                        }
                        else {
                            self.panelView.frame = CGRectMake(xOrigin,
                                self.panelView.frame.origin.y,
                                self.panelView.frame.size.width,
                                self.panelView.frame.size.height);
                        }
                    }, completion:nil)
        })
    }
    
    func snapOutDetailView (animated : Bool, completionHandler : (() -> Void)!) {
        if self.willShowMasterView != nil {
            self.willShowMasterView()
        }
        
        var xOrigin : CGFloat = self.view.frame.size.width + MASTER_OVERLAP
        if (animated) {
            if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil {
                self.panelViewRightConstraint.constant = -xOrigin
                self.panelViewLeftConstraint.constant = xOrigin
            }
            
            UIView.animateWithDuration(SNAP_DURATION,
                delay: 0.0,
                options: UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.CurveEaseOut | UIViewAnimationOptions.AllowAnimatedContent,
                animations: {
                    if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil {
                        self.view.layoutIfNeeded()
                    }
                    else {
                        self.panelView.frame = CGRectMake(xOrigin,
                            self.panelView.frame.origin.y,
                            self.panelView.frame.size.width,
                            self.panelView.frame.size.height)
                    }
                }, completion: { finished in
                    if finished {
                        if completionHandler != nil {
                            completionHandler()
                        }
                    }
            })
        }
        else {
            if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil  {
                self.panelViewRightConstraint.constant = -xOrigin
                self.panelViewLeftConstraint.constant = xOrigin
                self.view.layoutIfNeeded()
            }
            else {
                self.panelView.frame = CGRectMake(xOrigin,
                    self.panelView.frame.origin.y,
                    self.panelView.frame.size.width,
                    self.panelView.frame.size.height)
            }
            
            if completionHandler != nil {
                completionHandler()
            }
        }
    }
    
    func replaceMasterView (view : UIView) {
        for view in self.masterView.subviews {
            view.removeFromSuperview()
        }
        let frame = self.masterView.bounds
        view.frame = frame;
        self.masterView.insertSubview(view, atIndex: 0)
    }
    
    func showMasterViewAnimated (animated : Bool, completionHandler : (() -> Void)!) {
        if self.willShowMasterView != nil {
            self.willShowMasterView()
        }
        
        if !self.slidingEnabled {
            return;
        }
        
        var xOrigin : CGFloat = self.masterView.frame.origin.x + self.masterView.frame.size.width - MASTER_OVERLAP
        xOrigin -= SHADOW_WIDTH
        
        if (animated) {
            if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil  {
                self.panelViewRightConstraint.constant = -xOrigin
                self.panelViewLeftConstraint.constant = xOrigin
            }
            UIView.animateWithDuration(SNAP_DURATION,
                delay: 0.0,
                options: UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.CurveEaseOut | UIViewAnimationOptions.AllowAnimatedContent,
                animations: {
                    if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil {
                        self.view.layoutIfNeeded()
                    }
                    else {
                        self.panelView.frame = CGRectMake(xOrigin,
                            self.panelView.frame.origin.y,
                            self.panelView.frame.size.width,
                            self.panelView.frame.size.height)
                    }
                    
                },
                completion: { finished in
                    if finished {
                        if completionHandler != nil {
                            completionHandler()
                        }
                    }
            })
        }
        else {
            if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil {
                self.panelViewRightConstraint.constant = -xOrigin
                self.panelViewLeftConstraint.constant = xOrigin
                self.view.layoutIfNeeded()
            }
            else {
                self.panelView.frame = CGRectMake(xOrigin,
                    self.panelView.frame.origin.y,
                    self.panelView.frame.size.width,
                    self.panelView.frame.size.height)
            }
            if completionHandler != nil {
                completionHandler()
            }
        }
    }
    
    
    func showMasterView () {
        self.showMasterViewAnimated(true)
    }
    
    func showMasterViewAnimated (animated : Bool) {
        self.showMasterViewAnimated(true, completionHandler: nil)
    }
    
    func hideMasterViewWithCompletionHandler (completionHandler : (() -> Void)!) {
        if self.willHideMasterView != nil && self.detailsController != nil {
            self.willHideMasterView()
        }
        
        var xOrigin = self.masterView.frame.origin.x
        
        let minXOrigin = self.view.bounds.size.width - self.panelView.bounds.size.width;
        if (xOrigin < minXOrigin) {
            xOrigin = minXOrigin
        }
        
        xOrigin -= SHADOW_WIDTH
        
        if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil {
            self.panelViewRightConstraint.constant = -xOrigin
            self.panelViewLeftConstraint.constant = xOrigin
        }
        
        UIView.animateWithDuration(SNAP_DURATION,
            delay: 0.0,
            options: UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.CurveEaseOut | UIViewAnimationOptions.AllowAnimatedContent,
            animations: {
                if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil {
                    self.view.layoutIfNeeded()
                }
                else {
                    self.panelView.frame = CGRectMake(xOrigin,
                        self.panelView.frame.origin.y,
                        self.panelView.frame.size.width,
                        self.panelView.frame.size.height)
                }
            },
            completion: { finished in
                if finished {
                    if completionHandler != nil {
                        completionHandler()
                    }
                }
        })
    }
    
    func hideMasterView () {
        self.hideMasterViewWithCompletionHandler(nil)
    }
    
    func setMasterViewController (masterViewController : UIViewController) {
        if self.masterController != nil {
            if self.masterController.isKindOfClass(UINavigationController) {
                let nc = self.masterController as UINavigationController
                for vc in nc.viewControllers {
                    if vc.respondsToSelector(Selector("unloadController")) {
                        let control = UIControl()
                        control.sendAction(Selector("unloadController"), to: vc, forEvent: nil)
                    }
                }
            }
            else {
                var previousController: UIViewController = self.masterController as UIViewController
                if previousController.respondsToSelector(Selector("unloadController")) {
                    let control = UIControl()
                    control.sendAction(Selector("unloadController"), to: previousController, forEvent: nil)
                }
            }
            
            
            self.masterController.removeFromParentViewController()
            self.masterController = nil
        }
        
        self.masterController = masterViewController;
        self.addChildViewController(self.masterController)
        self.masterController.didMoveToParentViewController(self)
        
        if self.masterController.isKindOfClass(UINavigationController) {
            let navigationController = self.masterController as UINavigationController
            navigationController.delegate = self;
        }
        
        self.masterController.view.frame = self.masterView.bounds
        self.masterView.insertSubview(self.masterController.view, atIndex: 0)
    }
    
    
    func replaceMasterRightView (view : UIView) {
        for view in self.masterRightView.subviews {
            view.removeFromSuperview()
        }
        let frame = self.masterRightView.bounds
        view.frame = frame
        self.masterRightView.insertSubview(view, atIndex: 0)
    }
    
    func showMasterRightViewAnimated (animated : Bool, completionHandler : (() -> Void)!) {
        if !self.slidingEnabled {
            return;
        }
        
        self.masterRightView.hidden = false
        
        var xOrigin : CGFloat = self.masterRightView.frame.origin.x - self.panelView.frame.size.width + MASTER_OVERLAP
        xOrigin -= SHADOW_WIDTH;
        
        if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil {
            self.panelViewRightConstraint.constant = -xOrigin
            self.panelViewLeftConstraint.constant = xOrigin
        }
        
        if (animated) {
            UIView.animateWithDuration(SNAP_DURATION,
                delay: 0.0,
                options: UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.CurveEaseOut | UIViewAnimationOptions.AllowAnimatedContent,
                animations: {
                    if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil {
                        self.view.layoutIfNeeded()
                    }
                    else {
                        self.panelView.frame = CGRectMake(xOrigin,
                            self.panelView.frame.origin.y,
                            self.panelView.frame.size.width,
                            self.panelView.frame.size.height)
                    }
                },
                completion: { finished in
                    if finished {
                        if completionHandler != nil {
                            completionHandler()
                        }
                    }
            })
        }
        else {
            if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil {
                self.panelViewRightConstraint.constant = -xOrigin
                self.panelViewLeftConstraint.constant = xOrigin
                self.view.layoutIfNeeded()
            }
            else {
                self.panelView.frame = CGRectMake(xOrigin,
                    self.panelView.frame.origin.y,
                    self.panelView.frame.size.width,
                    self.panelView.frame.size.height)
            }
            
            if completionHandler != nil {
                completionHandler();
            }
        }
    }
    
    
    func showMasterRightView () {
        self.showMasterRightViewAnimated (true)
    }
    
    func showMasterRightViewAnimated (animated : Bool) {
        self.showMasterRightViewAnimated(true, completionHandler: nil)
    }
    
    func hideMasterRightViewWithCompletionHandler (completionHandler : (() -> Void)!) {
        var xOrigin : CGFloat = self.masterRightView.frame.origin.x + self.masterRightView.frame.size.width - self.panelView.frame.size.width
        
        let minXOrigin = self.view.bounds.size.width - self.panelView.bounds.size.width
        if (xOrigin < minXOrigin) {
            xOrigin = minXOrigin
        }
        
        xOrigin -= SHADOW_WIDTH;
        
        if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil {
            self.panelViewRightConstraint.constant = -xOrigin
            self.panelViewLeftConstraint.constant = xOrigin
        }
        
        UIView.animateWithDuration(SNAP_DURATION,
            delay: 0.0,
            options: UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.CurveEaseOut | UIViewAnimationOptions.AllowAnimatedContent,
            animations: {
                if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil {
                    self.view.layoutIfNeeded()
                }
                else {
                    self.panelView.frame = CGRectMake(xOrigin,
                        self.panelView.frame.origin.y,
                        self.panelView.frame.size.width,
                        self.panelView.frame.size.height);
                }
            },
            completion: { finished in
                if finished {
                    if completionHandler != nil {
                        completionHandler()
                    }
                }
        })
    }
    
    func hideMasterRightView () {
        self.hideMasterRightViewWithCompletionHandler(nil)
    }
    
    func setMasterRightViewController (masterViewController : UIViewController) {
        if self.masterRightController != nil {
            if self.masterRightController.isKindOfClass(UINavigationController) {
                let nc = self.masterRightController as UINavigationController
                for vc in nc.viewControllers {
                    if vc.respondsToSelector(Selector("unloadController")) {
                        let control = UIControl()
                        control.sendAction(Selector("unloadController"), to: vc, forEvent: nil)
                    }
                }
            }
            else {
                var previousController: UIViewController = self.masterRightController as UIViewController
                if previousController.respondsToSelector(Selector("unloadController")) {
                    let control = UIControl()
                    control.sendAction(Selector("unloadController"), to: previousController, forEvent: nil)
                }
            }

            self.masterRightController.removeFromParentViewController()
            self.masterRightController = nil
        }
        
        self.masterRightController = masterViewController
        self.addChildViewController(self.masterRightController)
        self.masterRightController.didMoveToParentViewController(self);
        
        if self.masterRightController.isKindOfClass(UINavigationController) {
            let nc = self.masterRightController as UINavigationController
            nc.delegate = self;
        }
        
        self.masterController.view.frame = self.masterRightView.bounds
        self.masterRightView.insertSubview(self.masterRightController.view, atIndex: 0)
    }
    
    func setDetailsViewController (detailsViewController : UIViewController) {
        if self.detailsController != nil {
            if self.detailsController.isKindOfClass(UINavigationController) {
                let nc = self.detailsController as UINavigationController
                for vc in nc.viewControllers {
                    if vc.respondsToSelector(Selector("unloadController")) {
                        let control = UIControl()
                        control.sendAction(Selector("unloadController"), to: vc, forEvent: nil)
                    }
                }
            }
            else {
                var previousController: UIViewController = self.detailsController as UIViewController
                if previousController.respondsToSelector(Selector("unloadController")) {
                    let control = UIControl()
                    control.sendAction(Selector("unloadController"), to: previousController, forEvent: nil)
                }
            }
            
            self.detailsController.removeFromParentViewController()
            self.detailsController = nil
        }
        
        self.detailsController = detailsViewController;
        self.addChildViewController(self.detailsController)
        self.detailsController.didMoveToParentViewController(self)
        
        if self.detailsController.isKindOfClass(UINavigationController) {
            let nc = self.detailsController as UINavigationController
            nc.delegate = self;
        }
        
        self.snapOutDetailView(true,
            completionHandler: {
                for view in self.detailsView.subviews {
                    view.removeFromSuperview()
                }
                let frame = self.detailsView.bounds
                self.detailsController.view.frame = frame
                self.detailsView.insertSubview(self.detailsController.view, atIndex:0)
                
                self.panelView.hidden = false;
                
                var xOrigin : CGFloat = 0.0
                
                let minXOrigin = self.view.bounds.size.width - self.panelView.bounds.size.width
                if (xOrigin < minXOrigin) {
                    xOrigin = minXOrigin
                }
                
                xOrigin -= SHADOW_WIDTH;
                
                if self.parentSlidingViewController != nil {
                    self.parentSlidingViewController.hideMasterView()
                }
                
                if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil {
                    self.panelViewRightConstraint.constant = -xOrigin
                    self.panelViewLeftConstraint.constant = xOrigin
                }
                
                UIView.animateWithDuration(SNAP_DURATION,
                    delay: 0.0,
                    options: UIViewAnimationOptions.AllowUserInteraction | UIViewAnimationOptions.CurveEaseOut | UIViewAnimationOptions.AllowAnimatedContent,
                    animations: {
                        if self.panelViewLeftConstraint != nil && self.panelViewRightConstraint != nil  {
                            self.view.layoutIfNeeded()
                        }
                        else {
                            self.panelView.frame = CGRectMake(xOrigin,
                                self.panelView.frame.origin.y,
                                self.panelView.frame.size.width,
                                self.panelView.frame.size.height)
                        }
                    },
                    completion: { finished in
                })
        })
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        self.hideMasterView()
        self.prepareViewController(viewController)
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.panelPanGestureRecognizer && otherGestureRecognizer.isKindOfClass(UIScreenEdgePanGestureRecognizer) {
            return true
        }
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.prepareViewController(segue.destinationViewController as UIViewController)
    }
    
    func prepareViewController (viewController : UIViewController) {
        if viewController.navigationController != nil {
            let nc = viewController.navigationController
            let rootViewController = nc?.viewControllers.first as UIViewController
            if (rootViewController != viewController) {
                if self.parentSlidingViewController != nil {
                    self.parentSlidingViewController.hideMasterView()
                }
            }
        }
        if viewController.isKindOfClass(UINavigationController) {
            let nc = viewController as UINavigationController
            let rootViewController = nc.viewControllers.first as UIViewController
            self.prepareViewController(rootViewController)
        }
        else if viewController.isKindOfClass(FPSlidingViewPanelViewController) {
            let slidingViewPanel = viewController as FPSlidingViewPanelViewController

            var shouldAddOptionButton : Bool = false
            if viewController.navigationController != nil {
                let nc = viewController.navigationController
                let rootViewController = nc?.viewControllers.first as UIViewController
                if rootViewController == viewController {
                    shouldAddOptionButton = true
                }
            }
            else {
                shouldAddOptionButton = true
            }
            
            // Left Button
            if slidingViewPanel.optionsLeftButton != nil {
                let optionItem: UIButton = slidingViewPanel.optionsLeftButton
                optionItem.enabled = shouldAddOptionButton
                optionItem.hidden = !shouldAddOptionButton
                
                if (shouldAddOptionButton) {
                    if optionItem.isKindOfClass(UIButton) {
                        let button: UIButton = optionItem
                        button.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
                        button.addTarget(self,
                            action: Selector("optionsButtonTapped:"),
                            forControlEvents: UIControlEvents.TouchUpInside)
                    }
                    
                }
                
                // Back Button
                if slidingViewPanel.backButton != nil {
                    let backButton: UIButton = slidingViewPanel.backButton
                    backButton.enabled = !shouldAddOptionButton
                    backButton.hidden = shouldAddOptionButton
                }
            }
            
            // Right Button
            if slidingViewPanel.optionsRightButton != nil {
                let optionItem: UIButton = slidingViewPanel.optionsRightButton
                
                if optionItem.isKindOfClass(UIButton) {
                    let button: UIButton = optionItem
                    button.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)
                    button.addTarget(self,
                        action: Selector("optionsRightButtonTapped:"),
                        forControlEvents: UIControlEvents.TouchUpInside)
                }
            }
            
            slidingViewPanel.slidingViewController = self
        }
//        else if ([viewController isKindOfClass:[FPSlidingViewTablePanelViewController class]]) {
//            BOOL shouldAddOptionButton = NO;
//            if (viewController.navigationController != NULL) {
//                if ([viewController.navigationController.viewControllers objectAtIndex:0] == viewController) {
//                    shouldAddOptionButton = YES;
//                }
//            }
//            else {
//                shouldAddOptionButton = YES;
//            }
//            
//            UIBarButtonItem *barOptionItem = [(FPSlidingViewPanelViewController*)viewController optionsBarButton];
//            [barOptionItem setEnabled:shouldAddOptionButton];
//            
//            UIButton *optionItem = [(FPSlidingViewPanelViewController*)viewController optionsLeftButton];
//            [optionItem setEnabled:shouldAddOptionButton];
//            
//            if (shouldAddOptionButton) {
//                if ([barOptionItem.customView isKindOfClass:[UIButton class]]) {
//                    UIButton* button = (UIButton*)barOptionItem.customView;
//                    [button removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
//                    [button addTarget:self action:@selector(optionsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//                }
//                
//                if ([optionItem isKindOfClass:[UIButton class]]) {
//                    UIButton* button = (UIButton*)barOptionItem.customView;
//                    [button removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
//                    [button addTarget:self action:@selector(optionsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//                }
//            }
//            
//            [(FPSlidingViewTablePanelViewController*)viewController setSlidingViewController:self];
//        }
    }
    
    func showPopUpWithViewController ( controller : UIViewController) {
//    let window = UIApplication.sharedApplication().keyWindow
//    self.popUpViewController.setView
//    [self.popUpViewController setViewController:controller];
//    [self.popUpViewController showInView:window animated:YES];
    }
    
    func hidePopUp () {
//    [self.popUpViewController hide:YES];
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
