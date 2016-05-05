//
//  Banner.swift
//  CCF
//
//  Created by Alex on 26/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class Banner: NSObject {
    var bannerurl: String?
    var banner: String?
    var verse: String?
    
    func setData(data: NSDictionary) {
        if let bannerurl = data.valueForKey("bannerurl") as? String {
            self.bannerurl = bannerurl
        }
        if let banner = data.valueForKey("banner") as? String {
            self.banner = banner
        }
        if let verse = data.valueForKey("verse") as? String {
            self.verse = verse
        }
    }
}
