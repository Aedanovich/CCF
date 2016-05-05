//
//  BibleViewController.swift
//  CCF
//
//  Created by Alex on 25/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

var BibleURL = "http://www.esvapi.org/v2/rest/readingPlanQuery?date="
var BibleKey = "&key=e43d263178c650d2"

class BibleViewController: WebViewController {
    var date: NSDate! = NSDate()
    
    override func reloadData() {
        let dateFormatter: NSDateFormatter! = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.stringFromDate(date)
        
        url = "\(BibleURL)\(dateString)\(BibleKey)"
        
        topBarSubtitleLabel.text = dateString

        super.reloadData()
    }
    
    @IBAction func previousDayButtonTapped(sender: AnyObject) {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        date = calendar.dateByAddingUnit(.Day,
            value: -1,
            toDate: date,
            options: NSCalendarOptions(rawValue: 0))

        reloadData()
    }

    @IBAction func nextDayButtonTapped(sender: AnyObject) {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        date = calendar.dateByAddingUnit(.Day,
            value: 1,
            toDate: date,
            options: NSCalendarOptions(rawValue: 0))
        
        reloadData()
    }
}
