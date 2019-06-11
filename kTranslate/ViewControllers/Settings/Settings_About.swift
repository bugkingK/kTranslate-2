//
//  Settings_About.swift
//  LogiAppManager-v2
//
//  Created by moon on 10/06/2019.
//  Copyright © 2019 banaple. All rights reserved.
//

import Cocoa

class Settings_About: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        guard let local_version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return
        }
        
        m_lbVersion.stringValue = "Version \(local_version)"
        
        guard let app_name = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
            return
        }
        
        m_appName.stringValue = app_name
    }
    @IBOutlet weak var m_lbVersion: NSTextField!
    @IBOutlet weak var m_appName: NSTextField!
}
