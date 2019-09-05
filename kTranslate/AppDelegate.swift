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
        
        let windowVC = NSStoryboard.make(sbName: "Main", vcName: "windowController") as! NSWindowController
        let contentVC = windowVC.contentViewController
        PopoverController.shared
            .setLayout("icon-status", vc: contentVC) { (shared) in
            if shared.popover.isShown {
                if !UserDefault.bool(forKey: .bAlways) {
                    shared.closePopover(sender: nil)
                }
            }
        }
        
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        UserDefaults.standard.synchronize()
    }

}

