//
//  UserDefaultsKey.swift
//  kTranslate
//
//  Created by moon on 11/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa



extension NSWindowController {
    open func showPopupView(_ sender:Any?) {
        PopoverController.sharedInstance().closePopover(sender: sender)
        self.showWindow(sender)
        self.window?.level = .screenSaver
        self.window?.makeKeyAndOrderFront(sender)
    }
}
