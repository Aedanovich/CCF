//
//  Event.swift
//  CCF
//
//  Created by Alex on 24/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class Event: NSObject {
    var name: String?
    var subname: String?
    var venue: String?
    var memberprice: String?
    var guestprice: String?
    var date: String?
    var starttime: String?
    var endtime: String?
    var verse: String?
    var details: String?
    var image: String?
    var form: String?
    
    func setData(data: NSDictionary) {
        if let name = data.valueForKey("name") as? String {
            self.name = name
        }
        if let subname = data.valueForKey("subname") as? String {
            self.subname = subname
        }
        if let venue = data.valueForKey("venue") as? String {
            self.venue = venue
        }
        if let memberprice = data.valueForKey("memberprice") as? String {
            self.memberprice = memberprice
        }
        if let guestprice = data.valueForKey("guestprice") as? String {
            self.guestprice = guestprice
        }
        if let date = data.valueForKey("date") as? String {
            self.date = date
        }
        if let starttime = data.valueForKey("starttime") as? String {
            self.starttime = starttime
        }
        if let endtime = data.valueForKey("endtime") as? String {
            self.endtime = endtime
        }
        if let verse = data.valueForKey("verse") as? String {
            self.verse = verse
        }
        if let details = data.valueForKey("details") as? String {
            self.details = details
        }
        if let image = data.valueForKey("image") as? String {
            self.image = image
        }
        if let form = data.valueForKey("form") as? String {
            self.form = form
        }
    }
}
