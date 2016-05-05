//
//  ForumViewController.swift
//  CCF
//
//  Created by Alex on 17/11/14.
//  Copyright (c) 2014 ChalkboxCreatives. All rights reserved.
//

import UIKit

let ForumURL = "http://ccfsingapore.org/forums"

class ForumViewController: WebViewController {
    override func viewDidLoad() {
        url = ForumURL
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
