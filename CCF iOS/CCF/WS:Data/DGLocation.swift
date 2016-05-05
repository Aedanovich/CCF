//
//  DGLocation.swift
//  CCF
//
//  Created by Alex on 17/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class DGLocation: NSObject {
    var location: String?
    var imageurl: String?
    var contact: String?
    var time: String?
    var day: String?
    var addressname: String?
    var latitude: NSNumber?
    var longitude: NSNumber?
    var email: String?
    var verse: String?
    var agerangemin: NSNumber?
    var agerangemax: NSNumber?

    func setData(data: NSDictionary) {
        if let location = data.valueForKey("location") as? String {
            self.location = location
        }
        if let imageurl = data.valueForKey("imageurl") as? String {
            self.imageurl = imageurl
        }
        if let contact = data.valueForKey("contact") as? String {
            self.contact = contact
        }
        if let time = data.valueForKey("time") as? String {
            self.time = time
        }
        if let day = data.valueForKey("day") as? String {
            self.day = day
        }
        if let addressname = data.valueForKey("addressname") as? String {
            self.addressname = addressname
        }
        if let latitude = data.valueForKey("latitude") as? NSNumber {
            self.latitude = latitude
        }
        if let longitude = data.valueForKey("longitude") as? NSNumber {
            self.longitude = longitude
        }
        if let email = data.valueForKey("email") as? String {
            self.email = email
        }
        if let verse = data.valueForKey("verse") as? String {
            self.verse = verse
        }
        if let agerangemin = data.valueForKey("agerangemin") as? NSNumber {
            self.agerangemin = agerangemin
        }
        if let agerangemax = data.valueForKey("agerangemax") as? NSNumber {
            self.agerangemax = agerangemax
        }

    }
}
