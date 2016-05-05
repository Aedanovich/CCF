//
//  VimeoViewController.swift
//  CCF
//
//  Created by Alex on 18/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class VimeoViewController: FPSlidingViewPanelViewController {
    var loading : Bool = false
    var video : VimeoVideo!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if let vc = slidingViewController as? ViewController {
            let playerViewController = vc.playerViewController

            if playerViewController.view.superview != nil {
                playerViewController.view.removeFromSuperview()
            }

            playerViewController.view.frame = CGRectMake(0,
                topBarView.bounds.size.height,
                view.bounds.size.width,
                view.bounds.size.height - topBarView.bounds.size.height)
            playerViewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            
            playerViewController.showsPlaybackControls = true
            view.insertSubview(playerViewController.view, atIndex: 0)
            
            vc.previewBarView.enableExpand = false
            vc.didStopPlayback = {
                dispatch_async(dispatch_get_main_queue(), {
                    self.backButtonTapped(nil)
                })
            }
        }
        
        reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        if let vc = slidingViewController as? ViewController {
            vc.previewBarView.enableExpand = true
        }
    }
    
    func reloadData() {
        if video != nil && !loading {
            loading = true
            
            let vimeoVideoId = video.id.stringValue
            
            self.loadingView.show(true)
            
            VimeoExtractor.fetchVideoURLFromID(vimeoVideoId,
                quality: YTVimeoVideoQuality.Medium,
                referer: nil,
                completionHandler: { videoURLDict in
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loadingView.show(false)
                    })
                    
                    if videoURLDict != nil {
                        self.video.videoURLDict = videoURLDict!

                        dispatch_async(dispatch_get_main_queue(), {
                            if let vc = self.slidingViewController as? ViewController {
                                vc.playVimeoVideo(self.video)
                            }
                        })
                    }
            })
        }
    }
}
