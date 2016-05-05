//
//  HomeViewController.swift
//  CCF
//
//  Created by Alex on 17/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

var DeviceIsIPad : Bool = UIDevice.currentDevice().userInterfaceIdiom == .Pad
var CellHeight : CGFloat = 44.0
var CellInterItemSpacing : CGFloat = 4.0
var CellColumns : CGFloat = DeviceIsIPad ? 3 : 2

let Sections: Int = 9
let BannerIndex: Int = 0
let VideosIndex: Int = 1
let BibleIndex: Int = 2
let CCFSingaporeIndex: Int = 3
let DGroupsIndex: Int = 4
let ServeIndex: Int = 5
let ForumsIndex: Int = 6
let EventsIndex: Int = 7
let ResourcesIndex: Int = 8

class HomeViewController: FPSlidingViewPanelViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var collectionView : UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Data Source
        collectionView.delegate = self
        collectionView.dataSource = self

        // Offset
        collectionView.contentInset = UIEdgeInsetsMake(TOP_COLLECTION_VIEW_SHORT_INSET, 0.0,
            BOTTOM_COLLECTION_VIEW_INSET, 0.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func unloadController() {
        super.unloadController()
        
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }

    // Collection View
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let dimensions = (view.bounds.size.width - (CellInterItemSpacing * (CellColumns + 1))) / CellColumns
        var width: CGFloat
        if DeviceIsIPad {
            if indexPath.row == 0 {
                width = (dimensions * 3) + (CellInterItemSpacing * 2)
            }
            else if indexPath.row == 1 || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 12 {
                width = (dimensions * 2) + CellInterItemSpacing
            }
            else {
                width = dimensions
            }
        }
        else {
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 6 || indexPath.row == 9 || indexPath.row == 14 {
                width = (dimensions * 2) + CellInterItemSpacing
            }
            else {
                width = dimensions
            }
        }
        return CGSizeMake(width, dimensions)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(CellInterItemSpacing, CellInterItemSpacing, CellInterItemSpacing, CellInterItemSpacing)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CellInterItemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CellInterItemSpacing - 0.1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Sections
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : HomeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCell", forIndexPath: indexPath) as! HomeCollectionViewCell
        
        cell.reset()
        
        switch indexPath.row {
        case BannerIndex:
            cell.titleBG.hidden = true
            cell.urlImageOverlay.hidden = true
            cell.urlImage.image = UIImage(named: "header_sg_1.png")
            break;
        case VideosIndex:
            cell.urlImage.image = UIImage(named: "home_bg_video.png")
            cell.titleLabel.text = "Videos"
            cell.subtitleLabel.text = "'Go therefore and make disciples of all the nations, baptizing them in the name of the Father and the Son and the Holy Spirit...'\nMatthew 28:19 (NASB)"
            break;
        case BibleIndex:
            cell.urlImage.image = UIImage(named: "home_bg_bible.png")
            cell.titleLabel.text = "Read"
            cell.subtitleLabel.text = "'...meditate on it day and night, so that you may be careful to do according to all that is written in it.'\nJoshua 1:8 (NASB)"
            break;
        case DGroupsIndex:
            cell.urlImage.image = UIImage(named: "home_bg_dg.png")
            cell.titleLabel.text = "DGroups"
            cell.subtitleLabel.text = "'For where two or three have gathered together in My name, I am there in their midst.'\nMatthew 18:20 (NASB)"
            break;
        case ForumsIndex:
            cell.urlImage.image = UIImage(named: "home_bg_forums.png")
            cell.titleLabel.text = "Forums"
            cell.subtitleLabel.text = "'So then, while we have opportunity, let us do good to all people, and especially to those who are of the household of the faith.'\nGalatians 6:10 (NASB)"
            
            break;
        case CCFSingaporeIndex:
            cell.titleBG.hidden = true
            cell.urlImageOverlay.hidden = true
            cell.urlImage.image = UIImage(named: "home_bg_ccf.png")
            break;
        case EventsIndex:
            cell.titleLabel.text = "Events"
            cell.urlImage.image = UIImage(named: "home_bg_event.png")
            break;
        case ResourcesIndex:
            cell.titleLabel.text = "Resources"
            cell.urlImage.image = UIImage(named: "home_bg_resources.png")
            break;
        case ServeIndex:
            cell.titleLabel.text = "Ministries"
            cell.urlImage.image = UIImage(named: "home_bg_serve.png")
            cell.subtitleLabel.text = "'As each one has received a special gift, employ it in serving one another as good stewards of the manifold grace of God.'\n1 Peter 4:10 (NASB)"
            break;
        default:
            break;
        }
        
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.layer.borderWidth = 0.5
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).CGPath

        return cell as UICollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case VideosIndex:
            slidingViewController.performSegueWithIdentifier(FP_SLIDING_VIEW_SEGUE_DETAIL + "_messages", sender: self)
            break;
        case BibleIndex:
            slidingViewController.performSegueWithIdentifier(FP_SLIDING_VIEW_SEGUE_DETAIL + "_bible", sender: self)
            break;
        case DGroupsIndex:
            slidingViewController.performSegueWithIdentifier(FP_SLIDING_VIEW_SEGUE_DETAIL + "_dgroups", sender: self)
            break;
        case ForumsIndex:
            slidingViewController.performSegueWithIdentifier(FP_SLIDING_VIEW_SEGUE_DETAIL + "_forum", sender: self)
            break;
        case CCFSingaporeIndex:
            slidingViewController.performSegueWithIdentifier(FP_SLIDING_VIEW_SEGUE_DETAIL + "_ccf", sender: self)
            break;
        case EventsIndex:
            slidingViewController.performSegueWithIdentifier(FP_SLIDING_VIEW_SEGUE_DETAIL + "_events", sender: self)
            break;
        case ResourcesIndex:
            slidingViewController.performSegueWithIdentifier(FP_SLIDING_VIEW_SEGUE_DETAIL + "_resources", sender: self)
            break;
        case ServeIndex:
            slidingViewController.performSegueWithIdentifier(FP_SLIDING_VIEW_SEGUE_DETAIL + "_serve", sender: self)
        default:
            break;
        }
    }

}
