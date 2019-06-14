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
        m_btnEmail.target = self
        m_btnEmail.action = #selector(onClickEmail)
        m_btnGit.target = self
        m_btnGit.action = #selector(onClickGit)
        m_btnPage.target = self
        m_btnPage.action = #selector(onClickPage)
    }
    @IBOutlet weak var m_lbVersion: NSTextField!
    @IBOutlet weak var m_appName: NSTextField!
    @IBOutlet weak var m_btnEmail: NSButton!
    @IBOutlet weak var m_btnGit: NSButton!
    @IBOutlet weak var m_btnPage: NSButton!
    
    @objc private func onClickEmail() {
        let mailtoURL = URL(string: "mailto:myway0710@naver.com")!
        NSWorkspace.shared.open(mailtoURL)
        MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.about, action: AnalyticsAction.openEmail, label: mailtoURL.absoluteString, value: 0)
    }
    
    @objc private func onClickGit() {
        let gitURL = URL(string: "https://github.com/bugkingK")!
        NSWorkspace.shared.open(gitURL)
        MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.about, action: AnalyticsAction.viewOnGitHub, label: gitURL.absoluteString, value: 0)
    }
    
    @objc private func onClickPage() {
        let pageURL = URL(string: "http://blog.bugking.tk")!
        NSWorkspace.shared.open(pageURL)
        MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.about, action: AnalyticsAction.viewOnPage, label: pageURL.absoluteString, value: 0)
    }
    
    
}
