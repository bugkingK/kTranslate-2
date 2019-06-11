//
//  Settings_Preferences.swift
//  LogiAppManager-v2
//
//  Created by moon on 10/06/2019.
//  Copyright © 2019 banaple. All rights reserved.
//

import Cocoa
import MASShortcut

class Settings_Preferences: NSViewController, NSTextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.setupLayout()
    }
    
    @IBOutlet weak var m_cbAutoLogin: NSButton!
    @IBOutlet weak var m_scShow: MASShortcutView!
    private func setupLayout() {
        m_cbAutoLogin.state = AutoLogin.enabled ? .on : .off
    }
    
    @objc func toggleAutostart(_ sender: NSButton) -> Void {
        AutoLogin.setEnabled(enabled: sender.state == .on)
    }
    
}

