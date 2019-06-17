//
//  Settings_Preferences.swift
//  LogiAppManager-v2
//
//  Created by moon on 10/06/2019.
//  Copyright © 2019 banaple. All rights reserved.
//

import Cocoa
import GoogleAnalyticsTracker
import MASShortcut

class Settings_Preferences: NSViewController {

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
    @IBOutlet weak var m_masShortcut: MASShortcutView!
    
    @IBOutlet weak var m_cbWidth: NSComboBox!
    @IBOutlet weak var m_cbHeight: NSComboBox!
    
    @IBOutlet weak var m_btnG: NSButton!
    @IBOutlet weak var m_btnP: NSButton!
    @IBOutlet weak var m_btnK: NSButton!
    private var m_arrGPK:[NSButton] = []
    private var m_preference_data:PreferenceData!
    struct PreferenceData {
        var nMainTranslator:Int
        var nWidth:String
        var nHeight:String
        var shortcutValue:MASShortcut?
    }
    
    private func setupLayout() {
        let defaults = UserDefaults.standard
        let bAutoLogin:Bool = AutoLogin.enabled
        m_btnAutoLogin.target = self
        m_btnAutoLogin.action = #selector(toggleAutostart(_:))
        m_btnAutoLogin.state = bAutoLogin ? .on : .off
        
        let bool_welcome = defaults.bool(forKey: UserDefaults_DEFINE_KEY.welcomeKey.rawValue)
        m_btnWelcome.target = self
        m_btnWelcome.action = #selector(toggleWelcome(_:))
        m_btnWelcome.state = bool_welcome ? .on : .off
        
        m_arrGPK = [m_btnG, m_btnP, m_btnK]
        let idx_domain = UserDefaults.standard.integer(forKey: UserDefaults_DEFINE_KEY.domainKey.rawValue)
        for btn in m_arrGPK {
            btn.target = self
            btn.action = #selector(onClickRadioGPK(_:))
            btn.state = btn.tag == idx_domain ? .on : .off
        }
        
        let value_width = defaults.string(forKey: UserDefaults_DEFINE_KEY.widthKey.rawValue)!
        let value_height = defaults.string(forKey: UserDefaults_DEFINE_KEY.heightKey.rawValue)!
        m_cbWidth.target = self
        m_cbWidth.action = #selector(onClickWindowSize(_:))
        m_cbHeight.target = self
        m_cbHeight.action = #selector(onClickWindowSize(_:))
        m_cbWidth.selectItem(withObjectValue: value_width)
        m_cbHeight.selectItem(withObjectValue: value_height)
        
        HotKeyManager.shared.registerHotKey(shortcutView: m_masShortcut)
        m_preference_data = PreferenceData(nMainTranslator: idx_domain, nWidth: value_width, nHeight: value_height, shortcutValue: m_masShortcut.shortcutValue)
    }
    
    @objc func toggleAutostart(_ sender: NSButton) {
        AutoLogin.enabled = sender.state == .on
//        AutoLogin.setEnabled(enabled: sender.state == .on)
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
        let defaults = UserDefaults.standard
        let b_dontShow = defaults.bool(forKey: UserDefaults_DEFINE_KEY.dontShowKey.rawValue)
        
        if !b_dontShow {
            CommonUtil.alertMessageWithKeep("kTranslate will continue to run in the background", "Do not show this message agin") {
                defaults.set(true, forKey: UserDefaults_DEFINE_KEY.dontShowKey.rawValue)
            }
        }
        
        let initKey = defaults.bool(forKey: UserDefaults_DEFINE_KEY.initKey.rawValue)
        let idx_domain = UserDefaults.standard.integer(forKey: UserDefaults_DEFINE_KEY.domainKey.rawValue)
        let value_width = defaults.string(forKey: UserDefaults_DEFINE_KEY.widthKey.rawValue)!
        let value_height = defaults.string(forKey: UserDefaults_DEFINE_KEY.heightKey.rawValue)!
        var shortcutString = "set any shortcut"
        
        if !initKey {
            defaults.set(true, forKey: UserDefaults_DEFINE_KEY.initKey.rawValue)
            var label:String?
            switch idx_domain {
                case 0:
                    label = AnalyticsLabel.google
                case 1:
                    label = AnalyticsLabel.papago
                case 2:
                    label = AnalyticsLabel.kakao
                default: break
            }
            MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.preference, action:AnalyticsAction.dTranslator, label: label, value: 0)
            MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.preference, action:AnalyticsAction.size, label:"\(value_width)-\(value_height)", value: 0)
            
            if let flags = m_masShortcut.shortcutValue?.modifierFlagsString, let keycode = m_masShortcut.shortcutValue?.keyCodeString {
                shortcutString = self.getShortCutString(shortCut: flags)+keycode
            }
            
            MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.preference, action:AnalyticsAction.shortCut, label: shortcutString, value: 0)
            
        } else {
            if m_preference_data.nMainTranslator != idx_domain {
                var label:String?
                switch idx_domain {
                case 0:
                    label = AnalyticsLabel.google
                case 1:
                    label = AnalyticsLabel.papago
                case 2:
                    label = AnalyticsLabel.kakao
                default: break
                }
                MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.preference, action:AnalyticsAction.dTranslator, label: label, value: 0)
            }
            
            if m_preference_data.nWidth != value_width || m_preference_data.nHeight != value_height {
                MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.preference, action:AnalyticsAction.size, label:"\(value_width)-\(value_height)", value: 0)
            }
            
            if let flags = m_masShortcut.shortcutValue?.modifierFlagsString, let keycode = m_masShortcut.shortcutValue?.keyCodeString {
                shortcutString = self.getShortCutString(shortCut: flags)+keycode
            }
            if m_preference_data.shortcutValue != m_masShortcut.shortcutValue {
                MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.preference, action:AnalyticsAction.shortCut, label: shortcutString, value: 0)
            }
        }
        
        PopoverController.sharedInstance().showPopover(sender: self)
        guard let vc_main = PopoverController.sharedInstance().getRootViewController() as? MainPopOverVC else {
            return
        }
        defaults.set(shortcutString, forKey: UserDefaults_DEFINE_KEY.shortCutStringKey.rawValue)
        vc_main.onChangeShortcutButton(shortCut: shortcutString)
    }
    
    private func getShortCutString(shortCut:String) -> String {
        var ret_value:String = ""
        
        for c_value in shortCut {
            if c_value == "⌘" {
                ret_value = ret_value+"Command + "
            }
            
            if c_value == "⇧" {
                ret_value = ret_value+"Shift + "
            }
            
            if c_value == "⌥" {
                ret_value = ret_value+"Option + "
            }
            
            if c_value == "⌃" {
                ret_value = ret_value+"Control + "
            }
        }
        
        return ret_value
    }
}
