//
//  MapTableViewCell.swift
//  CCF
//
//  Created by Alex on 27/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bannerView: FPURLImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!

    
    func setLocation(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let distance: CLLocationDistance = 1000.0
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(location, distance, distance)
        mapView.setRegion(region, animated: false)
        refreshMapWithLocation(location,
            locationName: name,
            updateTextInput: true)
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
    }
    
    // Map View
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
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

}
