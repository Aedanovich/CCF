//
//  DGGroup.swift
//  CCF
//
//  Created by Alex on 17/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class DGGroup: NSObject {
    var group: String?
    var gender: String?
    var locations: NSMutableArray = NSMutableArray(capacity: 0)
    
    func setData(data: NSDictionary) {
        if let group = data.valueForKey("group") as? String {
            self.group = group
        }
        if let gender = data.valueForKey("gender") as? String {
            self.gender = gender
        }

        locations.removeAllObjects()
        if let inputLocations = data.valueForKey("locations") as? NSArray {
            for input in inputLocations {
                let dgLocation = DGLocation()
                dgLocation.setData(input as! NSDictionary)
                locations.addObject(dgLocation)
            }
        }
    }
}