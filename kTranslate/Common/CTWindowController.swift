//
//  CTWindowController.swift
//  kTranslate
//
//  Created by bugking on 11/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

class CTWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
