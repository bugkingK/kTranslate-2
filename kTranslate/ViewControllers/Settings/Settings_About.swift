//
//  Settings_About.swift
//  LogiAppManager-v2
//
//  Created by moon on 10/06/2019.
//  Copyright © 2019 banaple. All rights reserved.
//

import Cocoa
import GoogleAnalyticsTracker

class Settings_About: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        m_appName.stringValue = BundleInfo.bundleName
        m_lbVersion.stringValue = "Version \(BundleInfo.version)"
        MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.about, action: AnalyticsAction.itself, label: "", value: 0)
    }
    
    @IBOutlet weak var m_lbVersion: NSTextField!
    @IBOutlet weak var m_appName: NSTextField!

    @IBAction private func onClickBtnProfile(_ sender:NSButton) {
        sender.state = .on
        var url:URL?
        var action:String?
        
        switch sender.tag {
            case 0:
                url = URL(string: "mailto:myway0710@naver.com")
                action = AnalyticsAction.mail
            case 1:
                url = URL(string: "https://github.com/bugkingK")
                action = AnalyticsAction.github
            case 2:
                url = URL(string: "http://blog.bugking.tk")
                action = AnalyticsAction.page
            default:
                break
        }
        
        guard let v_url = url, let v_action = action else { return }
        MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.about, action: v_action, label: "", value: 0)
        NSWorkspace.shared.open(v_url)
    }
    
    
}
