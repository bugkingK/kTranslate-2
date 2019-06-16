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
//    private var toggleKey: HotKey? {
//        didSet {
//            guard let toggleKey = toggleKey else {
//                return
//            }
//
//            toggleKey.keyDownHandler = { [weak self] in
//                PopoverController.sharedInstance().togglePopover(self)
//            }
//        }
//    }
    
    public func registerHotKey() {
//        toggleKey = HotKey(keyCombo: KeyCombo(key: .e, modifiers: [.command, .shift]))
        
        guard let fir_menu = NSApplication.shared.mainMenu?.items.first?.submenu?.items else {
            return
        }
        fir_menu[2].target = self
        fir_menu[2].action = #selector(onPreperences)
        
        
        guard let second_menu = NSApplication.shared.mainMenu?.items[1].submenu?.items else {
            return
        }
        guard let vc_main = PopoverController.sharedInstance().getRootViewController() as? MainPopOverVC else {
            return
        }
        
        for (idx, menu) in second_menu.enumerated() {
            menu.tag = idx
            menu.target = vc_main
            menu.action = #selector(vc_main.onChangeTranslate(_:))
        }
    }
    
    public func registerHotKey(shortcutView:MASShortcutView) {
        shortcutView.associatedUserDefaultsKey = globalShortcut
//        shortcutView.shortcutValue = MASShortcut(keyCode: 14, modifierFlags: [.])
    }
    
    @objc func onPreperences() {
        guard let vc = NSStoryboard.init(name: "Settings", bundle: nil).instantiateController(withIdentifier: "Settings_Preferences") as? Settings_Preferences else {
            return
        }
        let windowVC = CTWindowController(window: NSWindow(contentViewController: vc))
        windowVC.showWindow(self)
    }
}
