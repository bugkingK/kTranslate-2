//
//  HotKeyManager.swift
//  AirPodsManager
//
//  Created by moon on 05/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa
import MASShortcut

class HotKeyManager: NSObject {
    static let shared = HotKeyManager()
    private let globalShortcut = "GlobalShortcut"
    private let HOTKEY = "HOTKEY-SHORTCUT"
    
    public func registerHotKey() {
        MASShortcutBinder.shared()?.bindShortcut(withDefaultsKey: globalShortcut, toAction: { [weak self] in
            PopoverController.shared.togglePopover(self)
        })
    }
    
    public func registerHotKey(shortcutView:MASShortcutView) {
        shortcutView.associatedUserDefaultsKey = globalShortcut
        if !UserDefaults.standard.bool(forKey: HOTKEY) {
            shortcutView.shortcutValue = MASShortcut(keyCode: 14, modifierFlags: [.command, .shift])
            UserDefaults.standard.set(true, forKey: HOTKEY)
        }
    }
}
