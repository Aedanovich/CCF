//
//  DGroupDetailViewController.swift
//  CCF
//
//  Created by Alex on 19/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit
import MapKit
import MessageUI

class DGroupDetailViewController: FPSlidingViewPanelViewController, MKMapViewDelegate, MFMailComposeViewControllerDelegate {
    var data : DGLocation!
    var section : Section!
    
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var verseLabel : UILabel!
    
    @IBOutlet weak var imageView : FPKenBurnsView!
    @IBOutlet weak var nameLabel : UILabel!

    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressLabelHeight: NSLayoutConstraint!

    @IBOutlet weak var joinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        joinButton.layer.cornerRadius = 4.0
        joinButton.layer.masksToBounds = true
        
        tableView.contentInset = UIEdgeInsetsMake(TOP_COLLECTION_VIEW_XXLONG_INSET, 0.0, 0.0, 0.0)
        tableView.contentOffset = CGPointMake(0.0, -TOP_COLLECTION_VIEW_XXLONG_INSET)
        self.view.sendSubviewToBack(tableView)
        
        // Setup Controls
        reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func reloadData() {
        let name = data.location
        let image = data.imageurl
        let contact = data.contact
        let email = data.email
        let time = data.time
        let day = data.day
        let addressname = data.addressname
        let verse = data.verse

        nameLabel.text = name
        contactLabel.text = contact
        imageView.imageURL = image
        contactLabel.text = contact
        emailButton.setTitle(email, forState: .Normal)
        
        dayLabel.text = "Every " + day! as String
        timeLabel.text = "@" + time! as String
        addressLabel.text = addressname
        addressLabelHeight.constant = addressLabel.intrinsicContentSize().height + 8.0
        verseLabel.text = verse
        view.layoutIfNeeded()

        if data.latitude != nil && data.longitude != nil {
            let latitude: CLLocationDegrees = data.latitude!.doubleValue
            let longitude: CLLocationDegrees = data.longitude!.doubleValue
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let distance: CLLocationDistance = 1000.0
            let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(location, distance, distance)
            mapView.setRegion(region, animated: false)
            refreshMapWithLocation(location,
                locationName: addressname!,
                updateTextInput: true)
        }
        
        if section != nil {
            if image == nil || image?.characters.count == 0 {
                secondTopBarViewBGImage.clear()
                secondTopBarViewBGImage.setImageWithURL(section.banner, completion: nil)
            }
            if verse == nil || verse?.characters.count == 0 {
                secondTopBarViewLabel.text = section.text
            }
        }
    }
    
    func refreshMapWithLocation(location: CLLocationCoordinate2D, locationName: String, updateTextInput: Bool) {
        let annotation: MapViewAnnotation = MapViewAnnotation(coordinate: location, title: locationName as String, subtitle: "")
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
        
        // Radius in meters
        let coord1: CLLocationCoordinate2D = mapView.convertPoint(CGPointZero, toCoordinateFromView: mapView)
        let coord2:CLLocationCoordinate2D = mapView.convertPoint(CGPointMake(mapView.bounds.size.width, 0.0), toCoordinateFromView: mapView)
        let coord3:CLLocationCoordinate2D = mapView.convertPoint(CGPointMake(0.0, mapView.bounds.size.height), toCoordinateFromView: mapView)
        
        let location1: CLLocation = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
        let location2: CLLocation = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
        let location3: CLLocation = CLLocation(latitude: coord3.latitude, longitude: coord3.longitude)
        
        let distanceLatitudinal: CLLocationDistance = location1.distanceFromLocation(location2)
        let distanceLongitudinal: CLLocationDistance = location1.distanceFromLocation(location3)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(location, distanceLongitudinal, distanceLatitudinal)
        mapView.setRegion(region, animated: true)
        mapView.selectAnnotation(annotation, animated: true)
    }

    // Map View
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        let AnnotationIdentifier: String = "AnnotationIdentifier";
        let annotationView: CCFPinAnnotationView = CCFPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationIdentifier as String)
        annotationView.canShowCallout = true
        annotationView.iconView.image = UIImage(named: "icon_map_pin.png")
        annotationView.canShowCallout = true
        return annotationView
    }

    // IBAction
    @IBAction func joinButtonTapped(sender: AnyObject) {
        let emailTitle = "Inquiry for " + data.location! as String + " (" + data.contact! + ") DGroup"
        let messageBody = "Hi,\n\n[Please introduce yourself here]\n\nRegards,\n\n[Your Name]"

        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients([data.email!])
        
        self.presentViewController(mc, animated: true, completion: nil)
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
