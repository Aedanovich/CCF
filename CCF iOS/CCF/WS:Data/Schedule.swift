//
//  Schedule.swift
//  CCF
//
//  Created by Alex on 26/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class Schedule: NSObject {
    var banner: String?
    var title: String?
    var address: String?
    var latitude: NSNumber!
    var longitude: NSNumber!
    var starttime: String?
    var endtime: String?
    
    func setData(data: NSDictionary) {
        if let banner = data.valueForKey("banner") as? String {
            self.banner = banner
        }
        if let title = data.valueForKey("title") as? String {
            self.title = title
        }
        if let address = data.valueForKey("address") as? String {
            self.address = address
        }
        if let latitude = data.valueForKey("latitude") as? NSNumber {
            self.latitude = latitude
        }
        if let longitude = data.valueForKey("longitude") as? NSNumber {
            self.longitude = longitude
        }
        if let starttime = data.valueForKey("starttime") as? String {
            self.starttime = starttime
        }
        if let endtime = data.valueForKey("endtime") as? String {
            self.endtime = endtime
        }
    }
}
