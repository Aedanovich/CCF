//
//  Section.swift
//  CCF
//
//  Created by Alex on 25/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class Section: NSObject {
    var text: String!
    var banner: String!
    
    func setData(data: NSDictionary) {
        if let text = data.valueForKey("text") as? String {
            self.text = text
        }
        if let banner = data.valueForKey("banner") as? String {
            self.banner = banner
        }
    }
}
