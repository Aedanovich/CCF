//
//  DetailSection.swift
//  CCF
//
//  Created by Alex on 26/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

enum SectionType : UInt {
    case Text
    case Button
    case Map
}

class DetailSection: NSObject {
    var type: SectionType = .Text
    var header: String?
    var textcontent: String?
    var contents: NSMutableArray = NSMutableArray(capacity: 0)
    
    func setData(data: NSDictionary) {
        if let type = data.valueForKey("type") as? String {
            if type == "text" {
                self.type = .Text
            }
            else if type == "button" {
                self.type = .Button
            }
            else if type == "map" {
                self.type = .Map
            }
        }
        if let header = data.valueForKey("header") as? String {
            self.header = header
        }
        
        contents.removeAllObjects()
        // TEXT
        if type == .Text {
            if let textcontent = data.valueForKey("content") as? String {
                self.textcontent = textcontent
            }
        }
        else if let items = data.valueForKey("content") as? JSONArray {
            for item in items {
                // BUTTON ARRAY
                if type == .Button {
                    let obj = DetailButton()
                    obj.setData(item as! JSONDictionary)
                    contents.addObject(obj)
                }
                // MAP ARRAY
                else if type == .Map {
                    let obj = DetailMap()
                    obj.setData(item as! JSONDictionary)
                    contents.addObject(obj)
                }
            }
        }
    }
}
