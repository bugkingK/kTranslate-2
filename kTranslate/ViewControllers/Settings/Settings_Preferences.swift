//
//  Settings_Preferences.swift
//  LogiAppManager-v2
//
//  Created by moon on 10/06/2019.
//  Copyright © 2019 banaple. All rights reserved.
//

import Cocoa
//import MASShortcut

class Settings_Preferences: NSViewController, NSTextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.setupLayout()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        UserDefaults.standard.synchronize()
    }
    
    @IBOutlet weak var m_btnAutoLogin: NSButton!
    @IBOutlet weak var m_btnWelcome: NSButton!
    
    @IBOutlet weak var m_cbWidth: NSComboBox!
    @IBOutlet weak var m_cbHeight: NSComboBox!
    
    private func setupLayout() {
        m_btnAutoLogin.target = self
        m_btnAutoLogin.action = #selector(toggleAutostart(_:))
        m_btnAutoLogin.state = AutoLogin.enabled ? .on : .off
        m_cbWidth.target = self
        m_cbWidth.action = #selector(onClickWindowSize(_:))
        m_cbHeight.target = self
        m_cbHeight.action = #selector(onClickWindowSize(_:))
        m_btnWelcome.target = self
        m_btnWelcome.action = #selector(toggleWelcome(_:))
        
        let defaults = UserDefaults.standard
        
        let value_width = defaults.string(forKey: UserDefaults_DEFINE_KEY.widthKey.rawValue)
        let value_height = defaults.string(forKey: UserDefaults_DEFINE_KEY.heightKey.rawValue)
        
        m_cbWidth.selectItem(withObjectValue: value_width)
        m_cbHeight.selectItem(withObjectValue: value_height)
        
        let bool_welcome = defaults.bool(forKey: UserDefaults_DEFINE_KEY.welcomeKey.rawValue)
        m_btnWelcome.state = bool_welcome ? .on : .off
    }
    
    @objc func toggleAutostart(_ sender: NSButton) {
        AutoLogin.setEnabled(enabled: sender.state == .on)
    }
    
    @objc func toggleWelcome(_ sender: NSButton) {
        UserDefaults.standard.set(sender.state == .on, forKey: UserDefaults_DEFINE_KEY.welcomeKey.rawValue)
    }
    
    @objc private func onClickWindowSize(_ sender:NSComboBox) {
        guard let str_size = sender.objectValueOfSelectedItem as? String, let int_size = Int(str_size) else {
            return
        }
        
        let key = (sender.tag == 0) ? UserDefaults_DEFINE_KEY.widthKey : UserDefaults_DEFINE_KEY.heightKey
        UserDefaults.standard.set(int_size, forKey: key.rawValue)
    }
    
    
}

