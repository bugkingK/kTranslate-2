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
    
    var prevClipboard:String?
    
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
                if !UserDefault.bool(forKey: .bAlways) && !shared.isDragging {
                    shared.closePopover(sender: nil)
                }
            }
        }

        PopoverController.shared.setShowEvent { (shared) in
            if let clipboard = NSPasteboard.general.clipboardContent() {
                if self.prevClipboard != clipboard {
                    self.prevClipboard = clipboard
                    let vc = NSStoryboard.make(sbName: "Popup", vcName: "Popup_Alert") as! Popup_Alert
                    vc.presentVC = contentVC
                    vc.clipboardContent = clipboard
                    contentVC?.presentAsSheet(vc)
                }
            }
        }
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        UserDefaults.standard.synchronize()
    }
    
    fileprivate func LaunchInit() {
        if !UserDefault.bool(forKey: .bLaunchInit) {
            UserDefault.set(true, key: .bLaunchInit)
            UserDefault.set(false, key: .bAlways)
            UserDefault.set("400", key: .sWidth)
            UserDefault.set("600", key: .sHeight)
            
            UserDefault.set(true, key: .bTransGoogle)
            UserDefault.set(true, key: .bTransPapago)
            UserDefault.set(true, key: .bTransKakao)
            UserDefault.set(true, key: .bTranskTranslate)
            AutoLogin.enabled = false
            CTWindowController.showWindow(sbName: "Setting", vcName: "Setting_Preference")
        }
    }

}

