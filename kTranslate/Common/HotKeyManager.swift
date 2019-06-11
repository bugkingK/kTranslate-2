//
//  HotKeyManager.swift
//  AirPodsManager
//
//  Created by moon on 05/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa
import HotKey

class HotKeyManager: NSObject {
    static let shared = HotKeyManager()
    
    private var toggleKey: HotKey? {
        didSet {
            guard let toggleKey = toggleKey else {
                return
            }
            
            toggleKey.keyDownHandler = { [weak self] in
                PopoverController.sharedInstance().togglePopover(self)
            }
        }
    }
    
    public func registerHotKey() {
        toggleKey = HotKey(keyCombo: KeyCombo(key: .e, modifiers: [.command, .shift]))
        
        guard let fir_menu = NSApplication.shared.mainMenu?.items.first?.submenu?.items else {
            return
        }
        fir_menu[2].target = self
        fir_menu[2].action = #selector(onClickpreferences(_:))
        
    }
    
    @objc private func onClickpreferences(_ sender:NSMenuItem?) {
        let sb = NSStoryboard.init(name: "Settings", bundle: nil)
        guard let popup = sb.instantiateController(withIdentifier: "Settings_Window") as? NSWindowController else {
            return
        }
        popup.showPopupView(self)
    }
}
