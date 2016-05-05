//
//  ResourcesViewController.swift
//  CCF
//
//  Created by Alex on 19/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class ResourcesViewController: FPSlidingViewPanelViewController, UICollectionViewDataSource, UICollectionViewDelegate {
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
        WebServices.sharedInstance.resourcesList { (section: Section!, data : NSArray!) -> Void in
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
        let cellIdentifier = "ResourceCell"
        let cell : ResourceCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! ResourceCollectionViewCell
        
        customizeCell(cell, indexPath: indexPath)
        
        return cell as UICollectionViewCell
    }
    
    func customizeCell(cell: ResourceCollectionViewCell, indexPath: NSIndexPath) {
        let obj = data.objectAtIndex(indexPath.row) as! Resource
        
        cell.urlImage.clear()
        if let image = obj.image {
            cell.urlImage.setImageWithURL(image, completion: nil)
        }
        cell.titleLabel.text = obj.name
        cell.subtitleLabel.text = obj.publisher
        cell.verseLabel.text = obj.verse
        
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
        
        if let indexPaths = collectionView.indexPathsForSelectedItems() as NSArray! {
            if let indexPath = indexPaths[0] as? NSIndexPath {
                if let value = data[indexPath.row] as? Resource {
                    if let vc = segue.destinationViewController as? WebViewController {
                        vc.url = value.file
                        vc.titleText = value.name
                    }
                }
            }
        }
    }
}
