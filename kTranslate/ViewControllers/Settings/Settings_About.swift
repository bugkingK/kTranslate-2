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
        
        m_appName.stringValue = Bundle.main.infoDictionary?["CFBundleName"] as! String
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        m_lbVersion.stringValue = "Version \(version)"
    }
    
    @IBOutlet weak var m_lbVersion: NSTextField!
    @IBOutlet weak var m_appName: NSTextField!

    @IBAction private func onClickBtnProfile(_ sender:NSButton) {
        sender.state = .on
        var url:URL?
        
        switch sender.tag {
            case 0: url = URL(string: "mailto:myway0710@naver.com")
            case 1: url = URL(string: "https://github.com/bugkingK")
            case 2: url = URL(string: "https://bugkingk.github.io")
            default: break
        }
        
        guard let v_url = url else { return }
        NSWorkspace.shared.open(v_url)
    }
    
    
}
