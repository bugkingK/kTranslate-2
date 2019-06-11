//
//  AutoLogin.swift
//  kTranslate
//
//  Created by moon on 11/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa
import ServiceManagement

fileprivate let KEY_AUTOSTART = "launch_at_login"

open class AutoLogin: NSObject {
    class var enabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: KEY_AUTOSTART)
        }
    }
    
    open class func setEnabled(enabled: Bool) {
        let launcherAppIdentifier = "tk.bugking.LauncherApplication"
        SMLoginItemSetEnabled(launcherAppIdentifier as CFString, enabled)
        
        UserDefaults.standard.set(enabled, forKey: KEY_AUTOSTART)
    }
}
