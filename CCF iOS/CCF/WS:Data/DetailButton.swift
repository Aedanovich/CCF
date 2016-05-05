//
//  DetailButton.swift
//  CCF
//
//  Created by Alex on 27/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class DetailButton: NSObject {
    var type: String?
    var image: String?
    var value: String?

    func setData(data: NSDictionary) {
        if let type = data.valueForKey("type") as? String {
            self.type = type
        }
        if let image = data.valueForKey("image") as? String {
            self.image = image
        }
        if let value = data.valueForKey("value") as? String {
            self.value = value
        }
    }
}
