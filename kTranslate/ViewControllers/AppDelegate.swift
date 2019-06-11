//
//  AppDelegate.swift
//  AirPodsManager
//
//  Created by moon on 05/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        AutoLogin.setEnabled(enabled: true)
        UserDefaults.standard.setValue(0, forKey: UserDefaultsKey().domainKey, defalutValue: 0)
        PopoverController.sharedInstance()
        HotKeyManager.shared.registerHotKey()
    }

}

