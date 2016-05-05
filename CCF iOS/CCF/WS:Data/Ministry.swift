//
//  Ministry.swift
//  CCF
//
//  Created by Alex on 24/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class Ministry: NSObject {
    var name: String?
    var verse: String?
    var details: String?
    var image: String?
    var email: String?
    
    func setData(data: NSDictionary) {
        if let name = data.valueForKey("name") as? String {
            self.name = name
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
        if let email = data.valueForKey("email") as? String {
            self.email = email
        }
    }
}
