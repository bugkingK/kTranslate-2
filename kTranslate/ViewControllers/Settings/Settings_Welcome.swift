//
//  Settings_Welcome.swift
//  LogiAppManager-v2
//
//  Created by moon on 09/06/2019.
//  Copyright © 2019 banaple. All rights reserved.
//

import Cocoa

class Settings_Welcome: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        m_appName.stringValue = Bundle.main.infoDictionary?["CFBundleName"] as! String
    }
    
    @IBOutlet weak var m_appName: NSTextField!
    
}
