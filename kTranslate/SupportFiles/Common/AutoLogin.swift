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
    static let id = "tk.bugking.LauncherApplication"
    class var enabled: Bool {
        get {
            guard let jobs = (SMCopyAllJobDictionaries(kSMDomainUserLaunchd).takeRetainedValue() as? [[String: AnyObject]]) else {
                return false
            }
            let job = jobs.first { $0["Label"] as! String == id }
            return job?["OnDemand"] as? Bool ?? false
        }
        set {
            SMLoginItemSetEnabled(id as CFString, newValue)
        }
    }
}
