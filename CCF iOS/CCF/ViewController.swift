//
//  ViewController.swift
//  CCF
//
//  Created by Alex on 17/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MessageUI

typealias DidStopPlayback = () -> Void

class ViewController: FPSlidingViewController, MFMailComposeViewControllerDelegate {
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var buildNumberLabel: UILabel!

    // Preview Play
    var expandHeight: CGFloat = 0.0
    var didStopPlayback: DidStopPlayback!
    var playerViewController: AVPlayerViewController! = AVPlayerViewController()
    @IBOutlet weak var previewBarView: FPPreviewBarView!
    @IBOutlet weak var currentPlayingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var offsetViewHeight: NSLayoutConstraint!

    var categories : NSMutableArray = NSMutableArray(capacity: 0)
    
    @objc private func applicationDidEnterBackground() {
        if let mPlayer = playerViewController.player {
            mPlayer.performSelector(#selector(AVPlayer.play), withObject: nil, afterDelay: 0.1)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().endReceivingRemoteControlEvents()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background Mode
        let avAudioSession = AVAudioSession.sharedInstance()
        do { try avAudioSession.setCategory(AVAudioSessionCategoryPlayback) }
        catch {}

        // Notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.applicationDidEnterBackground), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        
        // AVPlayer
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("handleAVPlayerInterruption"),
            name: AVAudioSessionInterruptionNotification,
            object: AVAudioSession.sharedInstance())

        // Table View
        (masterView as! UITableView).scrollsToTop = false
        
        // Build Number
        let bundle: NSBundle! = NSBundle.mainBundle() as NSBundle
        let versionString = bundle.objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        let buildString = bundle.objectForInfoDictionaryKey("CFBundleVersion") as! String
        buildNumberLabel.text = "Version " + versionString + " Build (" + buildString + ")"
        
        // Reload
        reloadData()
        
        // Bottom View
        offsetViewHeight.constant = 0
        currentPlayingViewHeight.constant = 0
        view.layoutIfNeeded()
        
        // Preview Dragging
        view.bringSubviewToFront(previewBarView)
        addPreviewDragGesture()
        
        // Show Home Segue
        performSegueWithIdentifier(FP_SLIDING_VIEW_SEGUE_DETAIL + "_home", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reloadData () {
    }
    
    func showCurrentPlayingView(show: Bool) {
        let height: CGFloat = show ? 44.0 : 0.0
        offsetViewHeight.constant = height
        currentPlayingViewHeight.constant = height
        UIView.animateWithDuration(0.3,
            delay: 0.0,
            options: [.AllowUserInteraction, .CurveEaseOut],
            animations: {
                self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func toggleExpandCurrentPlayingView() {
        let expand = !(currentPlayingViewHeight.constant > 44.0) && previewBarView.enableExpand
        
        if expandHeight <= 0 {
            expandHeight = view.bounds.size.height * 0.5
        }
        let height: CGFloat = expand ? expandHeight : 44.0
        currentPlayingViewHeight.constant = height

        if expand {
            previewBarView.detailsViewHeight.constant = max(previewBarView.previewSubLabel.intrinsicContentSize().height + 8, 44)
        }
        else {
            previewBarView.detailsViewHeight.constant = 0
        }

        UIView.animateWithDuration(0.3,
            delay: 0.0,
            options: [.AllowUserInteraction, .CurveEaseOut],
            animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        
        if expand {
            if playerViewController.view.superview != nil {
                playerViewController.view.removeFromSuperview()
            }
            playerViewController.showsPlaybackControls = true
            playerViewController.view.frame = previewBarView.previewVideoView.bounds
            playerViewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            previewBarView.previewVideoView.insertSubview(playerViewController.view, atIndex: 0)
        }
    }
    
    // Current Playing
    func playVimeoVideo (video: VimeoVideo) {
        showCurrentPlayingView(true)
        
        if playerViewController.player != nil {
            playerViewController.player!.removeObserver(self, forKeyPath: "rate")
        }

        let key = video.videoURLDict.keys.first
        let url = video.videoURLDict[key!]
        playerViewController.player = AVPlayer(URL: NSURL(string: url!)!)
        playerViewController.player!.play()

        previewBarView.previewLabel.text = video.title
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        previewBarView.previewSubLabel.text = video.video_description! as String + "\nUploaded: " + formatter.stringFromDate(video.upload_date)
        previewBarView.previewImageView.clear()
        previewBarView.previewImageView.setImageWithURL(video.thumbnail_small!,
            thumbnail: true,
            completion: nil)
        
        playerViewController.player!.addObserver(self,
            forKeyPath: "rate",
            options: .New,
            context: nil)
    }
    
    func stopVimeoVideo() {
        playerViewController.player!.pause()
        playerViewController.player!.removeObserver(self, forKeyPath: "rate")
        playerViewController.player = nil
        
        if didStopPlayback != nil {
            didStopPlayback()
        }
        
        showCurrentPlayingView(false)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if object as? NSObject == playerViewController.player && keyPath == "rate" {
            if playerViewController.player!.rate > 0 {
                previewBarView.playButton.hidden = true
                previewBarView.pauseButton.hidden = false
            }
            else {
                previewBarView.playButton.hidden = false
                previewBarView.pauseButton.hidden = true
            }
        }
    }
    
    @IBAction func playPreviewButtonTapped(sender: AnyObject) {
        playerViewController.player!.play()
    }
    
    @IBAction func pausePreviewButtonTapped(sender: AnyObject) {
        playerViewController.player!.pause()
    }

    @IBAction func closePreviewButtonTapped(sender: AnyObject) {
        stopVimeoVideo()
    }

    @IBAction func expandPreviewButtonTapped(sender: AnyObject) {
        toggleExpandCurrentPlayingView()
    }
    
    @IBAction func phoneButtonTapped(sender: AnyObject) {
        let button = sender as! UIButton
        let phoneNumber: String? = button.titleLabel?.text
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + phoneNumber!.stringByReplacingOccurrencesOfString(" ", withString: ""))!)
    }
    
    @IBAction func emailButtonTapped(sender: AnyObject) {
        if let button = sender as? UIButton {
            let emailTitle = ""
            let messageBody = "Hi,\n\n[Please introduce yourself here]\n\nRegards,\n\n[Your Name]"
            let recipient: String? = button.titleLabel!.text! as String
            
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
    
    // Panning
    var previewOriginalPoint: CGPoint = CGPointZero
    var originalHeight: CGFloat = 0.0
    
    func addPreviewDragGesture () {
        let previewBarGesture = UIPanGestureRecognizer(target: self, action: Selector("handlePreviewBarViewPan:"))
        previewBarView.addGestureRecognizer (previewBarGesture)
    }
    
    func handlePreviewBarViewPan (panGestureRecognizer: UIPanGestureRecognizer) {
        if !previewBarView.enableExpand || !(currentPlayingViewHeight.constant > 44.0) {
            return
        }
        
        let state = panGestureRecognizer.state
        
        if state == UIGestureRecognizerState.Began {
            self.previewOriginalPoint = panGestureRecognizer.translationInView(previewBarView.superview!)
            originalHeight = expandHeight
        }
        else if state == UIGestureRecognizerState.Changed {
            let deltaPoint = panGestureRecognizer.translationInView(previewBarView.superview!)
            let delta : CGFloat = self.previewOriginalPoint.y - deltaPoint.y
            
            expandHeight = originalHeight + delta
            expandHeight = max(expandHeight, 44 + previewBarView.detailsViewHeight.constant + 100)
            expandHeight = min(expandHeight, view.bounds.size.height - 20)
            
            currentPlayingViewHeight.constant = expandHeight
            previewBarView.layoutIfNeeded()
        }
        else if state == UIGestureRecognizerState.Ended {
            let deltaPoint = panGestureRecognizer.translationInView(previewBarView.superview!)
            let delta : CGFloat = self.previewOriginalPoint.y - deltaPoint.y
            
            expandHeight = originalHeight + delta
            expandHeight = max(expandHeight, 44 + previewBarView.detailsViewHeight.constant + 100)
            expandHeight = min(expandHeight, view.bounds.size.height - 20)
            
            currentPlayingViewHeight.constant = expandHeight
            previewBarView.layoutIfNeeded()
            
            self.originalPoint = CGPointZero
        }
    }
}


// IBAction
extension ViewController {
    // Left Panel
    @IBAction func resourcesMenuButtonTapped(sender: AnyObject) {
        
    }
    
    // Right Panel
    @IBAction func facebookURLButtonTapped(sender: AnyObject) {
        let url = NSURL(string: "fb://profile/358579472793")!
        let application = UIApplication.sharedApplication()
        if  application.canOpenURL(url) {
            application.openURL(url)
        }
        else {
            let safariURL = NSURL(string: "https://www.facebook.com/CCF.sg")!
            application.openURL(safariURL)
        }
    }
    
    @IBAction func twitterURLButtonTapped(sender: AnyObject) {
        let url = NSURL(string: "twitter://user?screen_name=ccfsingapore")!
        let application = UIApplication.sharedApplication()
        if  application.canOpenURL(url) {
            application.openURL(url)
        }
        else {
            let safariURL = NSURL(string: "https://twitter.com/ccfsingapore")!
            application.openURL(safariURL)
        }
    }
    
    @IBAction func vimeoURLButtonTapped(sender: AnyObject) {
        let safariURL = NSURL(string: "https://vimeo.com/user7006079")!
        let application = UIApplication.sharedApplication()
        application.openURL(safariURL)
    }
}
//extension ViewController: AVAudioSessionDelegate {
//    override func remoteControlReceivedWithEvent(event: UIEvent?) {
//        let mPlayer = playerViewController.player!
//        switch event!.subtype {
//        case .RemoteControlTogglePlayPause:
//            if(mPlayer.rate == 0){
//                mPlayer.play()
//            } else {
//                mPlayer.pause()
//            }
//            break;
//        case .RemoteControlPlay:
//            mPlayer.play()
//            break;
//        case .RemoteControlPause:
//            mPlayer.pause()
//            break;
//        default:
//            break;
//        }
//
//    }
//}
