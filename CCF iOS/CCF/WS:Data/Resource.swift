//
//  Resource.swift
//  CCF
//
//  Created by Alex on 25/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class Resource: NSObject {
    var name: String?
    var publisher: String?
    var date: String?
    var verse: String?
    var details: String?
    var image: String?
    var file: String?
    
    func setData(data: NSDictionary) {
        if let name = data.valueForKey("name") as? String {
            self.name = name
        }
        if let publisher = data.valueForKey("publisher") as? String {
            self.publisher = publisher
        }
        if let date = data.valueForKey("date") as? String {
            self.date = date
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
        if let file = data.valueForKey("file") as? String {
            self.file = file
        }
    }
}
