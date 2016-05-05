//
//  VimeoVideo.swift
//  CCF
//
//  Created by Alex on 17/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

class VimeoVideo: NSObject {
    var id: NSNumber!
    var title: String?
    var video_description: String?
    var url: String?
    var upload_date: NSDate!
    var mobile_url: String?
    var thumbnail_small: String?
    var thumbnail_medium: String?
    var thumbnail_large: String?
    var user_id: NSNumber!
    var user_name: String?
    var user_url: String?
    var user_portrait_small: String?
    var user_portrait_medium: String?
    var user_portrait_large: String?
    var user_portrait_huge: String?
    var stats_number_of_likes: NSNumber!
    var stats_number_of_plays: NSNumber!
    var stats_number_of_comments: NSNumber!
    var duration: NSNumber!
    var width: NSNumber!
    var height: NSNumber!
    var tags: String?
    
    var videoURLDict: [String:String] = [:]
    
    
    func setData(data: NSDictionary) {
        let htmlTags: String = "<[^>]*>" //regex to remove any html tag

        id = data.valueForKey("id") as! NSNumber
        if let value = data.valueForKey("title") as? String {
            title = value
        }
        
        if let value = data.valueForKey("description") as? String {
            video_description = value
            video_description = video_description!.stringByReplacingOccurrencesOfString(htmlTags as String, withString: "")
        }
        
        url = data.valueForKey("url") as? String
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let dateString = data.valueForKey("upload_date") as? String {
            upload_date = df.dateFromString(dateString)
        }
        mobile_url = data.valueForKey("mobile_url") as? String
        thumbnail_small = data.valueForKey("thumbnail_small") as? String
        thumbnail_medium = data.valueForKey("thumbnail_medium") as? String
        thumbnail_large = data.valueForKey("thumbnail_large") as? String
        user_id = data.valueForKey("user_id") as! NSNumber
        user_name = data.valueForKey("user_name") as? String
        user_url = data.valueForKey("user_url") as? String
        user_portrait_small = data.valueForKey("user_portrait_small") as? String
        user_portrait_medium = data.valueForKey("user_portrait_medium") as? String
        user_portrait_large = data.valueForKey("user_portrait_large") as? String
        user_portrait_huge = data.valueForKey("user_portrait_huge") as? String
        stats_number_of_likes = data.valueForKey("stats_number_of_likes") as! NSNumber
        stats_number_of_plays = data.valueForKey("stats_number_of_plays") as! NSNumber
        stats_number_of_comments = data.valueForKey("stats_number_of_comments") as! NSNumber
        duration = data.valueForKey("duration") as! NSNumber
        width = data.valueForKey("width") as! NSNumber
        height = data.valueForKey("height") as! NSNumber
        tags = data.valueForKey("tags") as? String
    }
}
