//
//  UserDefaultsKey.swift
//  kTranslate
//
//  Created by moon on 11/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

enum UserDefaults_DEFINE_KEY:String {
    case domainKey = "number_translate_domain"
    case frameKey = "frameKey"
}

extension NSWindowController {
    open func showPopupView(_ sender:Any?) {
        PopoverController.sharedInstance().closePopover(sender: sender)
        self.showWindow(sender)
        self.window?.level = .screenSaver
        self.window?.makeKeyAndOrderFront(sender)
    }
}
