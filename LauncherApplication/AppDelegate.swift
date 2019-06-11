//
//  AppDelegate.swift
//  LauncherApplication
//
//  Created by moon on 11/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let mainAppIdentifier = "tk.bugking.kTranslate"
        
        let runningApps = NSWorkspace.shared.runningApplications
        let alreadyRunning = runningApps.filter { $0.bundleIdentifier == mainAppIdentifier }.count > 0
        
        if !alreadyRunning {
            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("kTranslate")
            
            let newPath = NSString.path(withComponents: components)
            
            NSWorkspace.shared.launchApplication(newPath)
        }
        self.terminate()
    }
    
    func terminate() {
        NSApp.terminate(nil)
    }
}

