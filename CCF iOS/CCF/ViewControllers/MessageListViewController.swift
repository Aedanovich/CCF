//
//  MessageListViewController.swift
//  CCF
//
//  Created by Alex on 17/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

enum FilterMode : UInt {
    case Recent
    case Alphabetical
}

class MessageListViewController: FPSlidingViewPanelViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var collectionView : UICollectionView!
    @IBOutlet var segmentControl : FPSegmentControl!
    var filterMode : FilterMode = FilterMode.Recent
    var videos : NSMutableArray = NSMutableArray(capacity: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Data Source
        collectionView.delegate = self
        collectionView.dataSource = self

        // Offset
        collectionView.contentInset = UIEdgeInsetsMake(TOP_COLLECTION_VIEW_XLONG_INSET, 0.0,
            BOTTOM_COLLECTION_VIEW_INSET, 0.0)
        view.sendSubviewToBack(collectionView)
        
        // View Mode Control
        switchFilterMode(FilterMode.Recent)
        segmentControl.setSelectedIndex(0)
        segmentControl.didSelectIndex = { index in
            self.switchFilterMode((index == 0) ? FilterMode.Recent : FilterMode.Alphabetical)
        }

        // Reload
        reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func unloadController() {
        super.unloadController()
        
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }
    
    func switchFilterMode (filterModeValue: FilterMode) {
        filterMode = filterModeValue
        
        sortVideos()
        
        collectionView.reloadData()
    }
    
    func sortVideos() {
        var descriptor: NSSortDescriptor
        if filterMode == FilterMode.Recent {
            descriptor = NSSortDescriptor(key: "upload_date", ascending: false)
        }
        else {
            descriptor = NSSortDescriptor(key: "title", ascending: true)
        }
        
        videos.sortUsingDescriptors([descriptor])
    }
    
    func reloadData() {
        loadingView.show(true)
        videos.removeAllObjects()
        WebServices.sharedInstance.videoArchives { (videos : NSArray?) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingView.show(false)
                self.videos.addObjectsFromArray(videos as [AnyObject]!)
                self.sortVideos()
                self.collectionView.reloadData()
            })
        }
    }
    
    // Collection View
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var height : CGFloat
        if filterMode == FilterMode.Recent {
            height = indexPath.row == 0 ? collectionView.bounds.size.height / 4 : 64.0
        }
        else {
            height = 64.0
        }
        let width : CGFloat = collectionView.bounds.size.width
        return CGSizeMake(width, height)
    }
        
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CellInterItemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CellInterItemSpacing
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cellIdentifier: String
        if filterMode == FilterMode.Recent {
            cellIdentifier = indexPath.row == 0 ? "RecentVideoCell" : "VideoCell"
        }
        else {
            cellIdentifier = "VideoCell"
        }
        let cell : MessageCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier as String, forIndexPath: indexPath) as! MessageCollectionViewCell
        
        customizeCell(cell, indexPath: indexPath)
        
        return cell as UICollectionViewCell
    }
    
    func customizeCell(cell: MessageCollectionViewCell, indexPath: NSIndexPath) {
        let video: VimeoVideo = videos[indexPath.row] as! VimeoVideo
        
        cell.titleLabel.text = video.title
        cell.descriptionLabel.text = video.video_description
        let imageURL = (indexPath.row == 0 && filterMode == FilterMode.Recent) ? video.thumbnail_large : video.thumbnail_small
        cell.videoThumbnailView.setImageWithURL(imageURL!,
            thumbnail: true,
            completion: nil)
        
        if cell.titleLabelHeightConstraint != nil {
            cell.titleLabelHeightConstraint.constant = cell.titleLabel.intrinsicContentSize().height + 2
        }
        
        if cell.descriptionLabelHeightConstraint != nil {
            cell.descriptionLabelHeightConstraint.constant = cell.descriptionLabel.intrinsicContentSize().height
        }
        
        cell.layoutIfNeeded()
        
        if filterMode == FilterMode.Recent && indexPath.row == 0 {
            cell.layer.shadowRadius = 1.0
            cell.layer.shadowOffset = CGSizeMake(0.0, 2.0);
            cell.layer.shadowOpacity = 0.3
            cell.layer.shadowColor = UIColor.blackColor().CGColor
            cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).CGPath
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let vc = segue.destinationViewController as? VimeoViewController {
            if let indexPaths = collectionView.indexPathsForSelectedItems() as NSArray! {
                if let indexPath = indexPaths[0] as? NSIndexPath {
                    let video: VimeoVideo = videos[indexPath.row] as! VimeoVideo
                    vc.video = video
                }
            }
        }
    }
}
