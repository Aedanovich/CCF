//
//  WebViewController.swift
//  CCF
//
//  Created by Alex on 18/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class WebViewController: FPSlidingViewPanelViewController, UIWebViewDelegate {
    var url : String?
    var titleText : String?
    var section : Section!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var webView : UIWebView!
    @IBOutlet var webViewActivityIndicatorView : UIActivityIndicatorView!
    @IBOutlet var webViewBackButton : UIButton!
    @IBOutlet var webViewForwardButton : UIButton!
    @IBOutlet var webViewRefreshButton : UIButton!
    @IBOutlet var webViewCancelButton : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        if webView != nil {
            webView.delegate = self
        }

        if secondTopBarView != nil {
            webView.scrollView.contentInset = UIEdgeInsetsMake(secondTopBarView.bounds.size.height, 0.0,
                0.0, 0.0)
        }
        else if topBarView != nil {
            webView.scrollView.contentInset = UIEdgeInsetsMake(topBarView.bounds.size.height, 0.0,
                0.0, 0.0)
        }
        view.sendSubviewToBack(webView)

        webView.scrollView.delegate = self

        updateControls()
        reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func unloadController() {
        super.unloadController()
        
        if webView != nil {
            webView.delegate = nil
            webView.scrollView.delegate = nil
        }
    }

    // Controls
    func reloadData() {
        if url != nil {
            let urlRequest = NSURLRequest(URL: NSURL(string: url! as String)!)
            webView.loadRequest(urlRequest)
        }
        if titleText != nil {
            titleLabel.text = titleText
        }
    }
    
    func updateControls() {
        if webViewBackButton != nil {
            let enableBack = webView.canGoBack as Bool
            webViewBackButton.alpha = enableBack ? 0.8 : 0.4
            webViewBackButton.userInteractionEnabled = enableBack
        }

        if webViewForwardButton != nil {
            let enableForward = webView.canGoForward as Bool
            webViewForwardButton.alpha = enableForward ? 0.8 : 0.4
            webViewForwardButton.userInteractionEnabled = enableForward
        }
    
        if webViewRefreshButton != nil {
            if webView.loading {
                webViewRefreshButton.hidden = true
            }
            else {
                webViewRefreshButton.hidden = false
            }
        }
        
        if webViewCancelButton != nil {
            if webView.loading {
                webViewCancelButton.hidden = false
            }
            else {
                webViewCancelButton.hidden = true
            }
        }
    }
    
    // WebView Delegate
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        webViewActivityIndicatorView.stopAnimating()
        updateControls()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webViewActivityIndicatorView.stopAnimating()
        updateControls()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        webViewActivityIndicatorView.startAnimating()
        updateControls()
    }
    
    // IBAction
    @IBAction func webViewBackButtonTapped(sender: AnyObject) {
        webView.goBack()
    }
    
    @IBAction func webViewForwardButtonTapped(sender: AnyObject) {
        webView.goForward()
    }
    
    @IBAction func webViewRefreshButtonTapped(sender: AnyObject) {
        webView.reload()
    }
    
    @IBAction func webViewCancelButtonTapped(sender: AnyObject) {
        webView.stopLoading()
    }
}
