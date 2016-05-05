//
//  EventsViewController.swift
//  CCF
//
//  Created by Alex on 19/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class EventsViewController: FPSlidingViewPanelViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var collectionView : UICollectionView!
    var data : NSMutableArray = NSMutableArray(capacity: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Data Source
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Offset
        collectionView.contentInset = UIEdgeInsetsMake(secondTopBarView.bounds.size.height, 0.0,
            BOTTOM_COLLECTION_VIEW_INSET, 0.0)
        view.sendSubviewToBack(collectionView)
        
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
    
    func reloadData() {
        loadingView.show(true)
        data.removeAllObjects()
        WebServices.sharedInstance.eventsList { (section: Section!, data : NSArray!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingView.show(false)

                if data != nil {
                    self.data.addObjectsFromArray(data as [AnyObject])
                    self.collectionView.reloadData()
                }
                
                if section != nil {
                    self.secondTopBarViewBGImage.clear()
                    self.secondTopBarViewBGImage.setImageWithURL(section.banner, completion: nil)
                    self.secondTopBarViewLabel.text = section.text
                }
            })
        }
    }
    
    // Collection View
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let dimensions = (view.bounds.size.width - (CellInterItemSpacing * 2))
        let height : CGFloat = dimensions / 2
        let width : CGFloat = dimensions
        return CGSizeMake(width, height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(CellInterItemSpacing, CellInterItemSpacing, CellInterItemSpacing, CellInterItemSpacing)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CellInterItemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return CellInterItemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdentifier = "EventCell"
        let cell : EventCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! EventCollectionViewCell
        
        customizeCell(cell, indexPath: indexPath)
        
        return cell as UICollectionViewCell
    }
    
    func customizeCell(cell: EventCollectionViewCell, indexPath: NSIndexPath) {
        let event = data.objectAtIndex(indexPath.row) as! Event
        
        cell.urlImage.clear()
        if event.image != nil {
            cell.urlImage.setImageWithURL(event.image!, completion: nil)
        }
        cell.titleLabel.text = event.name
        cell.subtitleLabel.text = event.subname
        let string = NSMutableString(capacity: 0)
        if event.venue != nil {
            string.appendString(event.venue! + "\n")
        }
        if event.date != nil {
            string.appendString(event.date!)
        }
        if event.starttime != nil {
            string.appendString(", ")
            string.appendString(event.starttime!)
        }
        if event.endtime != nil && event.endtime?.characters.count > 0 {
            string.appendString(" - ")
            string.appendString(event.endtime!)
        }
        cell.venueLabel.text = string as String
        cell.didTapJoinButton = { cell in
            if let index = self.collectionView.indexPathForCell(cell) {
                if self.data.count > index.row {
                    if let selEvent = self.data.objectAtIndex(index.row) as? Event {
                        if selEvent.form != nil && selEvent.form!.characters.count > 0 {
                            if let vc = self.pushControllerWithIdentifier("segue_webview") as? WebViewController {
                                vc.url = selEvent.form
                                vc.titleText = selEvent.name
                            }
                        }
                    }
                }
            }
        }
        
        cell.hideFormButton(event.form == nil || event.form!.characters.count == 0)
        
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        cell.layer.borderWidth = 0.5
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowColor = UIColor.blackColor().CGColor
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).CGPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
    }
}
