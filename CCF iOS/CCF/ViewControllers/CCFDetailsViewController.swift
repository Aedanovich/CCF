//
//  CCFDetailsViewController.swift
//  CCF
//
//  Created by Alex on 18/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit
import MapKit
import MessageUI

let CCFDetailsSections = 4
let MissionIndex = 0
let VisionIndex = 1
let ScheduleIndex = 2
let ContactIndex = 3

class CCFDetailsViewController: FPSlidingViewPanelViewController, MFMailComposeViewControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    var ccfDetails: CCFDetail!
    @IBOutlet weak var tableView : UITableView!
    
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var bannerImageView: FPURLImageView!
    
    var textCellHeight: CGFloat = 44.0
    var buttonCellHeight: CGFloat = 44.0
    var mapCellHeight: CGFloat = 220.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsetsMake(TOP_COLLECTION_VIEW_XXLONG_INSET, 0.0, 0.0, 0.0)
        tableView.contentOffset = CGPointMake(0.0, -TOP_COLLECTION_VIEW_XXLONG_INSET)
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 44.0
        
        self.view.sendSubviewToBack(tableView)
        
        // Setup Controls
        reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reloadData() {
        loadingView.show(true)
        WebServices.sharedInstance.ccfdetails { (detail: CCFDetail!) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingView.show(false)
                
                if detail != nil {
                    self.ccfDetails = detail
                    self.tableView.reloadData()
                }
            })
        }
        
        
        //        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(1.299463, 103.847714)
        //        let distance: CLLocationDistance = 1000.0
        //        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(location, distance, distance)
        //        mapView.setRegion(region, animated: false)
        //        refreshMapWithLocation(location,
        //            locationName: "CCF Singapore",
        //            updateTextInput: true)
        //
        //        mapViewDetailsHeight.constant = mapViewDetailsLabel.intrinsicContentSize().height + 8.0
        //        view.layoutIfNeeded()
    }
    
    func refreshMapWithLocation(location: CLLocationCoordinate2D, locationName: String, updateTextInput: Bool) {
        
//        let annotation: MapViewAnnotation = MapViewAnnotation(coordinate: location, title: locationName, subtitle: "")
//        mapView.removeAnnotations(mapView.annotations)
//        mapView.addAnnotation(annotation)
//        
//        // Radius in meters
//        let coord1: CLLocationCoordinate2D = mapView.convertPoint(CGPointZero, toCoordinateFromView: mapView)
//        let coord2:CLLocationCoordinate2D = mapView.convertPoint(CGPointMake(mapView.bounds.size.width, 0.0), toCoordinateFromView: mapView)
//        let coord3:CLLocationCoordinate2D = mapView.convertPoint(CGPointMake(0.0, mapView.bounds.size.height), toCoordinateFromView: mapView)
//        
//        let location1: CLLocation = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
//        let location2: CLLocation = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
//        let location3: CLLocation = CLLocation(latitude: coord3.latitude, longitude: coord3.longitude)
//        
//        let distanceLatitudinal: CLLocationDistance = location1.distanceFromLocation(location2)
//        let distanceLongitudinal: CLLocationDistance = location1.distanceFromLocation(location3)
//        
//        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(location, distanceLongitudinal, distanceLatitudinal)
//        mapView.setRegion(region, animated: true)
//        mapView.selectAnnotation(annotation, animated: true)
    }
    
    // Table View
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell")! as UITableViewCell
        
        if let label = cell.viewWithTag(1) as? UILabel {
            if ccfDetails != nil {
                if let detailSection = ccfDetails.sections.objectAtIndex(section) as? DetailSection {
                    if detailSection.header != nil {
                        label.text = detailSection.header
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 0
        if ccfDetails != nil {
            if let detailSection = ccfDetails.sections.objectAtIndex(section) as? DetailSection {
                switch detailSection.type {
                case .Text:
                    rows = 1
                    break;
                case .Button:
                    rows = detailSection.contents.count
                    break;
                case .Map:
                    rows = detailSection.contents.count
                    break;
                }
            }
        }
        
        return rows + 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if ccfDetails != nil {
            return ccfDetails.sections.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.delegate?.tableView!(tableView, viewForHeaderInSection: indexPath.section) as! UITableViewCell
            return cell
        }
        else {
            var identifier: String?
            if let detailSection = ccfDetails.sections.objectAtIndex(indexPath.section) as? DetailSection {
                switch detailSection.type {
                case .Text:
                    identifier = "TextCell"
                    break;
                case .Button:
                    identifier = "ButtonCell"
                    break;
                case .Map:
                    identifier = "MapCell"
                    break;
                }
            }
            
            let cell = ((tableView.dequeueReusableCellWithIdentifier(identifier!)! as UITableViewCell))
            
            if let detailSection = ccfDetails.sections.objectAtIndex(indexPath.section) as? DetailSection {
                switch detailSection.type {
                case .Text:
                    if let label = cell.viewWithTag(1) as? UILabel {
                        label.text = detailSection.textcontent
                    }
                    break;
                case .Button:
                    if let buttonDetail = detailSection.contents.objectAtIndex(indexPath.row - 1) as? DetailButton {
                        if let button = cell.viewWithTag(1) as? UIButton {
                            button.setTitle(buttonDetail.value, forState: .Normal)
                        }
                        if let imageView = cell.viewWithTag(2) as? FPURLImageView {
                            imageView.setImageWithURL(buttonDetail.image!, completion: nil)
                        }
                    }
                    break;
                case .Map:
                    if let mapDetail = detailSection.contents.objectAtIndex(indexPath.row - 1) as? DetailMap {
                        if let mapCell = cell as? MapTableViewCell {
                            mapCell.setLocation(mapDetail.address!,
                                latitude: mapDetail.latitude.doubleValue,
                                longitude: mapDetail.longitude.doubleValue)
                            let text = (mapDetail.starttime! as String) + "-" + mapDetail.endtime! + "\n" + mapDetail.address!
                            mapCell.scheduleLabel.text = text
                            mapCell.titleLabel.text = mapDetail.title
                            mapCell.bannerView.clear()
                            mapCell.bannerView.setImageWithURL(mapDetail.banner!, completion: nil)
                        }
                    }
                    break;
                }
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            
        }
        else {
            if let detailSection = ccfDetails.sections.objectAtIndex(indexPath.section) as? DetailSection {
                switch detailSection.type {
                case .Text:

                    break;
                case .Button:
                    if let buttonDetail = detailSection.contents.objectAtIndex(indexPath.row - 1) as? DetailButton {
                        if buttonDetail.type == "phone" {
                            phoneTapped(buttonDetail.value!)
                        }
                        else if buttonDetail.type == "email" {
                            emailTapped(buttonDetail.value!)
                        }
                    }
                    break;
                case .Map:

                    break;
                }
            }
        }
    }
    
    // IBAction
    func phoneTapped(sender: AnyObject) {
        if let phoneNumber = sender as? String {
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://" + phoneNumber.stringByReplacingOccurrencesOfString(" ", withString: ""))!)
        }
    }
    
    func emailTapped(sender: AnyObject) {
        if let recipient: String? = sender as? String {
            let emailTitle = ""
            let messageBody = "Hi,\n\n[Please introduce yourself here]\n\nRegards,\n\n[Your Name]"
            
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
}
