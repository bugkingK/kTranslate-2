//
//  UserDefaultsKey.swift
//  kTranslate
//
//  Created by moon on 11/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

extension UserDefaults {
    open func setValue(_ value: Any?, forKey key: String, defalutValue: Any?) {
        if self.value(forKey: key) == nil {
            self.setValue(defalutValue, forKey: key)
        } else {
            self.setValue(value, forKey: key)
        }
        self.synchronize()
    }
}

class UserDefaultsKey {
    let domainKey = "number_translate_domain"
}

extension NSWindowController {
    open func showPopupView(_ sender:Any?) {
        PopoverController.sharedInstance().closePopover(sender: sender)
        self.showWindow(sender)
        self.window?.level = .screenSaver
        self.window?.makeKeyAndOrderFront(sender)
    }
}
