//
//  FPPickerView.swift
//  CCF
//
//  Created by Alex on 20/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit


typealias DidPickItem = (item: String?) -> Void

class FPPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate {
    var didPickItem: DidPickItem!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var items : NSMutableArray! = NSMutableArray(capacity: 0)
    var setItems: NSArray {
        get {
            return items
        }
        set (newArray) {
            items.removeAllObjects()
            items.addObjectsFromArray(newArray as [AnyObject])
            pickerView.reloadAllComponents()
        }
    }
    
    override func awakeFromNib() {
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label: UILabel = UILabel()
        label.font = UIFont(name: "IowanOldStyle-Bold", size: 14)
        label.textAlignment = .Center
        label.text = items[row] as! String as String
        label.frame = CGRectMake(0, 0, self.bounds.size.width, 44)
        
        return label
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row < items.count {
            if didPickItem != nil {
                didPickItem(item: items[row] as? String)
            }
        }
    }
}
