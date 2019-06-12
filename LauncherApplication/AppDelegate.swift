//
//  AppDelegate.swift
//  LauncherApplication
//
//  Created by moon on 11/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

//@NSApplicationMain
//class AppDelegate: NSObject, NSApplicationDelegate {
//
//
//    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        let mainAppIdentifier = "tk.bugking.kTranslate"
//
//        let runningApps = NSWorkspace.shared.runningApplications
//        let alreadyRunning = runningApps.filter { $0.bundleIdentifier == mainAppIdentifier }.count > 0
//
//        if !alreadyRunning {
//            let path = Bundle.main.bundlePath as NSString
//            var components = path.pathComponents
//            components.removeLast(3)
//            components.append("MacOS")
//            components.append("kTranslate")
//
//            let newPath = NSString.path(withComponents: components)
//
//            NSWorkspace.shared.launchApplication(newPath)
//        }
//        self.terminate()
//    }
//
//    func terminate() {
//        NSApp.terminate(nil)
//    }
//}
//
extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}

@NSApplicationMain
class AppDelegate: NSObject {
    
    @objc func terminate() {
        NSApp.terminate(nil)
    }
}

extension AppDelegate: NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let mainAppIdentifier = "tk.bugking.kTranslate"
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = !runningApps.filter { $0.bundleIdentifier == mainAppIdentifier }.isEmpty
        
        if !isRunning {
            DistributedNotificationCenter.default().addObserver(self,
                                                                selector: #selector(self.terminate),
                                                                name: .killLauncher,
                                                                object: mainAppIdentifier)
            
            let path = Bundle.main.bundlePath as NSString
            var components = path.pathComponents
            components.removeLast()
            components.removeLast()
            components.removeLast()
            components.append("MacOS")
            components.append("kTranslate") //main app name
            
            let newPath = NSString.path(withComponents: components)
            
            NSWorkspace.shared.launchApplication(newPath)
        }
//        else {
        self.terminate()
//        }
    }
}
