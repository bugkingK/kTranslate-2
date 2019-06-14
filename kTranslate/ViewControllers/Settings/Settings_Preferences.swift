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
        self.view.window?.delegate = self
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        UserDefaults.standard.synchronize()
    }
    
    @IBOutlet weak var m_btnAutoLogin: NSButton!
    @IBOutlet weak var m_btnWelcome: NSButton!
    
    @IBOutlet weak var m_cbWidth: NSComboBox!
    @IBOutlet weak var m_cbHeight: NSComboBox!
    
    @IBOutlet weak var m_btnG: NSButton!
    @IBOutlet weak var m_btnP: NSButton!
    @IBOutlet weak var m_btnK: NSButton!
    private var m_arrGPK:[NSButton] = []
    private var m_preference_data:PreferenceData!
    struct PreferenceData {
        var bLogin:Bool
        var bHideStartup:Bool
        var nMainTranslator:Int
        var nWidth:String
        var nHeight:String
    }
    
    private func setupLayout() {
        m_arrGPK = [m_btnG, m_btnP, m_btnK]
        let idx_domain = UserDefaults.standard.integer(forKey: UserDefaults_DEFINE_KEY.domainKey.rawValue)
        for btn in m_arrGPK {
            btn.target = self
            btn.action = #selector(onClickRadioGPK(_:))
            btn.state = btn.tag == idx_domain ? .on : .off
        }
        
        let bAutoLogin:Bool = AutoLogin.enabled
        m_btnAutoLogin.state = bAutoLogin ? .on : .off
        m_btnAutoLogin.target = self
        m_btnAutoLogin.action = #selector(toggleAutostart(_:))
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
        
//        m_preference_data = PreferenceData(bLogin: bAutoLogin, bHideStartup: bool_welcome, nMainTranslator: idx_domain, nWidth: value_width, nHeight: value_height)
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
    
    @objc private func onClickRadioGPK(_ sender:NSButton) {
        for btn in self.m_arrGPK {
            btn.state = sender == btn ? .on : .off
        }
        UserDefaults.standard.set(sender.tag, forKey: UserDefaults_DEFINE_KEY.domainKey.rawValue)
    }
    
}

extension Settings_Preferences: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        
    }
}
