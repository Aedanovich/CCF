
//
//  DGroupViewController.swift
//  CCF
//
//  Created by Alex on 17/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

let BaseTopBarHeight: CGFloat = 148.0

class DGroupViewController: FPSlidingViewPanelViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView : UICollectionView!
    @IBOutlet weak var picker : FPPickerView!
    @IBOutlet weak var filterExpandView : FPExpandInputView!
    var groupName : String? = "All Groups"
    var rawdata : NSMutableArray = NSMutableArray(capacity: 0)
    var data : NSMutableArray = NSMutableArray(capacity: 0)
    var section : Section!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Data Source
        collectionView.delegate = self
        collectionView.dataSource = self

        // Offset
        collectionView.contentInset = UIEdgeInsetsMake(BaseTopBarHeight + self.filterExpandView.totalViewHeight.constant, 0.0,
            BOTTOM_COLLECTION_VIEW_INSET, 0.0)
        view.sendSubviewToBack(collectionView)
        
        // Reload
        picker.didPickItem = { item in
            self.groupName = item
            self.filterExpandView.expandButton.setTitle(item, forState: .Normal)
            self.reloadFilteredData()
        }

        filterExpandView.didChangeHeight = {
            self.secondTopBarHeightConstraint.constant = BaseTopBarHeight + self.filterExpandView.totalViewHeight.constant
            self.collectionView.contentInset = UIEdgeInsetsMake(self.secondTopBarHeightConstraint.constant, 0.0,
                BOTTOM_COLLECTION_VIEW_INSET, 0.0)            
            self.view.layoutIfNeeded()

            if self.secondTopBarView != nil {
                self.secondTopBarView.layer.shadowRadius = 1.0
                self.secondTopBarView.layer.shadowOffset = CGSizeMake(0.0, 2.0);
                self.secondTopBarView.layer.shadowOpacity = 0.3
                self.secondTopBarView.layer.shadowColor = UIColor.blackColor().CGColor
                self.secondTopBarView.layer.shadowPath = UIBezierPath(rect: self.secondTopBarView.bounds).CGPath
            }
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
//        collectionView.dataSource = nil
    }
    
    func reloadData() {
        loadingView.show(true)
        rawdata.removeAllObjects()
        WebServices.sharedInstance.dgrouplist { (section: Section!, data : NSArray!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingView.show(false)
                
                if data != nil {
                    self.rawdata.addObjectsFromArray(data as [AnyObject])
                    
                    let groupNames = NSMutableArray(capacity: 0)
                    groupNames.addObject("All Groups")
                    for group in self.rawdata {
                        let dggroup = group as! DGGroup
                        groupNames.addObject(dggroup.group!)
                    }
                    self.picker.setItems = groupNames
                    
                    self.reloadFilteredData()
                }

                if section != nil {
                    self.section = section
                    self.secondTopBarViewBGImage.clear()
                    self.secondTopBarViewBGImage.setImageWithURL(section.banner, completion: nil)
                    self.secondTopBarViewLabel.text = section.text
                }
            })
        }
    }
    
    func reloadFilteredData () {
        data.removeAllObjects()
        if groupName != nil && groupName?.characters.count > 0 && groupName != "All Groups" {
            for group in rawdata {
                let dggroup = group as! DGGroup
                if dggroup.group == groupName {
                    data.addObject(group)
                    break
                }
            }
        }
        else {
            data.addObjectsFromArray(rawdata as [AnyObject])
        }
        self.collectionView.reloadData()
    }
    
    // Collection View
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader,
            withReuseIdentifier: "GroupHeaderView",
            forIndexPath: indexPath) as! DGroupHeaderCollectionReusableView

        let group = data.objectAtIndex(indexPath.section) as? DGGroup
        reusableView.groupLabel.text = group?.group
        
        return reusableView
    }
    
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

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let group = data.objectAtIndex(section) as? DGGroup
        return group!.locations.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cellIdentifier = "DGroupCell"
        let cell : DGroupCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! DGroupCollectionViewCell
        
        customizeCell(cell, indexPath: indexPath)
        
        return cell as UICollectionViewCell
    }
    
    func customizeCell(cell: DGroupCollectionViewCell, indexPath: NSIndexPath) {
        if let group = data.objectAtIndex(indexPath.section) as? DGGroup {
            if let location = group.locations.objectAtIndex(indexPath.row) as? DGLocation {
                cell.locationLabel.text = location.location
                cell.contactLabel.text = location.contact
                cell.dayLabel.text = "Every " + location.day! as String + " @ " + location.time!
                cell.genderLabel.text = group.gender
                cell.imageView.clear()
                if location.imageurl != nil && location.imageurl?.characters.count > 0 {
                    cell.imageView.setImageWithURL(location.imageurl!, completion: nil)
                }
            }
        }
        
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
        
        if let vc = segue.destinationViewController as? DGroupDetailViewController {
            if let indexPaths = collectionView.indexPathsForSelectedItems() as NSArray! {
                if let indexPath = indexPaths[0] as? NSIndexPath {
                    let group = data.objectAtIndex(indexPath.section) as? DGGroup
                    let locations = group!.locations
                    let location = locations.objectAtIndex(indexPath.row) as? DGLocation
                    vc.data = location
                    vc.section = section
                }
            }
        }
        else if let vc = segue.destinationViewController as? StaticTextViewController {
            vc.section = section
        }
    }
}
