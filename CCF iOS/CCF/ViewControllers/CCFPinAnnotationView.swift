//
//  CCFPinAnnotationView.swift
//  CCF
//
//  Created by Alex on 20/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit
import MapKit

class CCFPinAnnotationView: MKAnnotationView {
    var icon: UIImage!
    var iconView: UIImageView! = UIImageView(frame: CGRectMake(-10, 4, 44, 44))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        centerOffset = CGPointMake(-9, -3)
        calloutOffset = CGPointMake(-2, 3)
        
        addSubview(iconView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
