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
        NSApp.activate(ignoringOtherApps: true)
        HotKeyManager.shared.registerHotKey()
//        UserDefault.clear()
        LaunchInit()
        
        let windowVC = NSStoryboard.make(sbName: "Main", vcName: "windowController") as! NSWindowController
        let contentVC = windowVC.contentViewController
        PopoverController.shared
            .setLayout("icon-status", vc: contentVC) { (shared) in
            Analyst.shared.track(event: .using)
            if shared.popover.isShown {
                if !UserDefault.bool(forKey: .bAlways) {
                    shared.closePopover(sender: nil)
                }
            }
        }
        
        PopoverController.shared.setShowEvent { (shared) in
            if let clipboard = NSPasteboard.general.clipboardContent() {
                CommonUtil.alertMessage(clipboard)
            }
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        UserDefaults.standard.synchronize()
    }
    
    fileprivate func LaunchInit() {
        if !UserDefault.bool(forKey: .bLaunchInit) {
            CTWindowController.showWindow(sbName: "Setting", vcName: "Setting_Preference")
            UserDefault.set(true, key: .bLaunchInit)
            UserDefault.set(false, key: .bAlways)
            UserDefault.set("400", key: .sWidth)
            UserDefault.set("600", key: .sHeight)
            AutoLogin.enabled = false
        }
    }

}

