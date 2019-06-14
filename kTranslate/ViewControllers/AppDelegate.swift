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
        MPGoogleAnalyticsTracker.activate(.init(analyticsIdentifier: "UA-141906441-2"))
        MPGoogleAnalyticsTracker.trackScreen("Main View")
        
        PopoverController.sharedInstance()
        HotKeyManager.shared.registerHotKey()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        UserDefaults.standard.synchronize()
    }

}

