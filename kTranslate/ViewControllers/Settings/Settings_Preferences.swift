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
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        UserDefaults.standard.synchronize()
    }
    
    @IBOutlet weak var m_cbAutoLogin: NSButton!
    @IBOutlet weak var m_cbFrame: NSComboBox!
    
    private func setupLayout() {
        m_cbAutoLogin.action = #selector(toggleAutostart(_:))
        m_cbAutoLogin.state = AutoLogin.enabled ? .on : .off
        
        let idx_selected = UserDefaults.standard.integer(forKey: UserDefaults_DEFINE_KEY.frameKey.rawValue)
        m_cbFrame.selectItem(at: idx_selected)
    }
    
    @objc func toggleAutostart(_ sender: NSButton) -> Void {
        AutoLogin.setEnabled(enabled: sender.state == .on)
    }
    
    @IBAction func onClickFrame(_ sender: NSComboBox) {
        let idx_selected = sender.indexOfSelectedItem
        UserDefaults.standard.set(idx_selected, forKey: UserDefaults_DEFINE_KEY.frameKey.rawValue)
    }
    
    
}

