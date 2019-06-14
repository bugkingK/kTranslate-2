//
//  AppDelegate.swift
//  AirPodsManager
//
//  Created by moon on 05/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa
import GoogleAnalyticsTracker

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        UserDefaults.standard.DEFINE_Clear()
        MPGoogleAnalyticsTracker.activate(.init(analyticsIdentifier: "UA-141906441-2"))
        MPGoogleAnalyticsTracker.trackScreen("Main View")
        
        self.initUserDefaultKey()
        self.showWelcome()
        
        PopoverController.sharedInstance()
        HotKeyManager.shared.registerHotKey()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        UserDefaults.standard.synchronize()
    }
    
    private func initUserDefaultKey() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: UserDefaults_DEFINE_KEY.initKey.rawValue) == nil {
            defaults.set(true, forKey: UserDefaults_DEFINE_KEY.initKey.rawValue)
            defaults.set("400", forKey: UserDefaults_DEFINE_KEY.widthKey.rawValue)
            defaults.set("500", forKey: UserDefaults_DEFINE_KEY.heightKey.rawValue)
            AutoLogin.setEnabled(enabled: true)
        }
    }
    
    private func showWelcome() {
        // defaultValue false
        let isShowWelcome = UserDefaults.standard.bool(forKey: UserDefaults_DEFINE_KEY.welcomeKey.rawValue)
        if !isShowWelcome {
            UserDefaults.standard.set(true, forKey: UserDefaults_DEFINE_KEY.welcomeKey.rawValue)
            UserDefaults.standard.synchronize()
            
            guard let vc = NSStoryboard.init(name: "Settings", bundle: nil).instantiateController(withIdentifier: "Settings_Window") as? NSWindowController else {
                return
            }
            vc.window?.level = .modalPanel
            vc.showWindow(self)
            
        }
    }

}

