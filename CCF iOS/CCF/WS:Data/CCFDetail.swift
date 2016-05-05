//
//  CCFDetail.swift
//  CCF
//
//  Created by Alex on 26/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class CCFDetail: NSObject {
    var details: String?
    var sections: NSMutableArray = NSMutableArray(capacity: 0)
    var banners: NSMutableArray = NSMutableArray(capacity: 0)
    
    func setData(data: NSDictionary) {
        if let details = data.valueForKey("details") as? String {
            self.details = details
        }
        
        banners.removeAllObjects()
        if let items = data.valueForKey("banners") as? JSONArray {
            for item in items {
                let obj = Banner()
                obj.setData(item as! JSONDictionary)
                banners.addObject(obj)
            }
        }

        sections.removeAllObjects()
        if let items = data.valueForKey("sections") as? JSONArray {
            for item in items {
                let obj = DetailSection()
                obj.setData(item as! JSONDictionary)
                sections.addObject(obj)
            }
        }
    }
}
