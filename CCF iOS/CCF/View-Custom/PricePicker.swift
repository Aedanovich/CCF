//
//  PricePicker.swift
//  Directist
//
//  Created by Alex on 11/11/14.
//  Copyright (c) 2014 Chalkbox Creatives. All rights reserved.
//

import UIKit

typealias DidPickPriceRange = (priceRange: String) -> Void

class PricePicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    var didPickPriceRange: DidPickPriceRange!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var ranges : NSMutableArray! = NSMutableArray(capacity: 0)
    
    override func awakeFromNib() {
        ranges.addObjectsFromArray(["Free", "$1 - $49", "$50 - $99", "$100 - $199", "$200 - $299", "$300 - $499", "$500 - $999",
            "$1000 - $1999", "$2000 - $2999", "$3000 - $3999", "$4000 - $4999", "$5000 and above"])
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ranges.count
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label: UILabel = UILabel()
        label.font = UIFont(name: "GillSans", size: 20)
        label.textAlignment = .Center
        label.text = ranges[row] as! String as String
        label.frame = CGRectMake(0, 0, self.bounds.size.width, 44)
        
        return label
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row < ranges.count {
            if didPickPriceRange != nil {
                didPickPriceRange(priceRange: ranges[row] as! String)
            }
        }
    }
}
