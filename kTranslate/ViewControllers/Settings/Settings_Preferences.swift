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
    @IBOutlet weak var m_cbMenuWIdth: NSComboBox!
    
    @IBOutlet weak var m_tfNameCM1: NSTextField!
    @IBOutlet weak var m_tfNameCM2: NSTextField!
    @IBOutlet weak var m_tfNameCM3: NSTextField!
    @IBOutlet weak var m_tfNameCM4: NSTextField!
    @IBOutlet weak var m_tfNameCM5: NSTextField!
    private var m_arrNameCM:[NSTextField]!
    
    @IBOutlet weak var m_tfAddressCM1: NSTextField!
    @IBOutlet weak var m_tfAddressCM2: NSTextField!
    @IBOutlet weak var m_tfAddressCM3: NSTextField!
    @IBOutlet weak var m_tfAddressCM4: NSTextField!
    @IBOutlet weak var m_tfAddressCM5: NSTextField!
    private var m_arrAddressCM:[NSTextField]!
    private var m_arrSiteName:[String] = {
        return UserDefaults.standard.array(forKey: DEFINE_KEY.siteNameKey.rawValue) as! [String]
    }()
    private var m_arrSiteAddress:[String] = {
        return UserDefaults.standard.array(forKey: DEFINE_KEY.siteAddressKey.rawValue) as! [String]
    }()
    
    private func setupLayout() {
        let defaults = UserDefaults.standard
        
        m_arrNameCM = [m_tfNameCM1, m_tfNameCM2, m_tfNameCM3, m_tfNameCM4, m_tfNameCM5]
        m_arrAddressCM = [m_tfAddressCM1, m_tfAddressCM2, m_tfAddressCM3, m_tfAddressCM4, m_tfAddressCM5]
        
        for idx in 0..<m_arrSiteName.count {
            m_arrNameCM[idx].target = self
            m_arrNameCM[idx].action = #selector(onChangeTFSite(_:))
            m_arrNameCM[idx].stringValue = m_arrSiteName[idx]
            m_arrAddressCM[idx].target = self
            m_arrAddressCM[idx].action = #selector(onChangeTFSite(_:))
            m_arrAddressCM[idx].stringValue = m_arrSiteAddress[idx]
        }
        
        let bAutoLogin:Bool = AutoLogin.enabled
        m_btnAutoLogin.target = self
        m_btnAutoLogin.action = #selector(toggleAutostart(_:))
        m_btnAutoLogin.state = bAutoLogin ? .on : .off
        
        let bool_welcome = defaults.bool(forKey: DEFINE_KEY.welcomeKey.rawValue)
        m_btnWelcome.target = self
        m_btnWelcome.action = #selector(toggleWelcome(_:))
        m_btnWelcome.state = bool_welcome ? .on : .off
        
        var v_width = defaults.string(forKey: DEFINE_KEY.widthKey.rawValue)
        if v_width == nil {
            defaults.set("400", forKey: DEFINE_KEY.widthKey.rawValue)
            v_width = "400"
        }
        
        var v_height = defaults.string(forKey: DEFINE_KEY.heightKey.rawValue)
        if v_height == nil {
            defaults.set("400", forKey: DEFINE_KEY.heightKey.rawValue)
            v_height = "600"
        }
        
        var v_menu_width = defaults.string(forKey: DEFINE_KEY.menuWidthKey.rawValue)
        if v_menu_width == nil {
            defaults.set("200", forKey: DEFINE_KEY.menuWidthKey.rawValue)
            v_menu_width = "200"
        }
        
        m_cbWidth.target = self
        m_cbWidth.action = #selector(onClickWindowSize(_:))
        m_cbHeight.target = self
        m_cbHeight.action = #selector(onClickWindowSize(_:))
        m_cbMenuWIdth.target = self
        m_cbMenuWIdth.action = #selector(onClickWindowSize(_:))
        m_cbWidth.selectItem(withObjectValue: v_width)
        m_cbHeight.selectItem(withObjectValue: v_height)
        m_cbMenuWIdth.selectItem(withObjectValue: v_menu_width)
        
        HotKeyManager.shared.registerHotKey(shortcutView: m_masShortcut)
    }
    
    @objc func toggleAutostart(_ sender: NSButton) {
        AutoLogin.enabled = sender.state == .on
    }
    
    @objc func toggleWelcome(_ sender: NSButton) {
        UserDefaults.standard.set(sender.state == .on, forKey: DEFINE_KEY.welcomeKey.rawValue)
    }
    
    @objc private func onClickWindowSize(_ sender:NSComboBox) {
        guard let str_size = sender.objectValueOfSelectedItem as? String, let int_size = Int(str_size) else {
            return
        }
        
        var key = ""
            switch sender.tag {
            case 0:
                key = DEFINE_KEY.widthKey.rawValue
            case 1:
                key = DEFINE_KEY.heightKey.rawValue
            case 2:
                key = DEFINE_KEY.menuWidthKey.rawValue
            default: break
        }
        
        UserDefaults.standard.set(int_size, forKey: key)
    }
    
    @objc private func onChangeTFSite(_ sender:NSTextField) {
        let tag = sender.tag
        let value = sender.stringValue
        
        switch tag {
        case 0..<5:
            self.m_arrSiteName[tag] = value
            UserDefaults.standard.set(self.m_arrSiteName, forKey: DEFINE_KEY.siteNameKey.rawValue)
        case 5..<10:
            self.m_arrSiteAddress[tag-5] = value
            UserDefaults.standard.set(self.m_arrSiteAddress, forKey: DEFINE_KEY.siteAddressKey.rawValue)
        default: break
        }
    }
}

extension Settings_Preferences: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        let defaults = UserDefaults.standard
        let b_dontShow = defaults.bool(forKey: DEFINE_KEY.dontShowKey.rawValue)
        var shortcutString = "set any shortcut"
        
        if !b_dontShow {
            CommonUtil.alertMessageWithKeep("kTranslate will continue to run in the background", "Do not show this message agin") {
                defaults.set(true, forKey: DEFINE_KEY.dontShowKey.rawValue)
            }
        }
        
        if let flags = m_masShortcut.shortcutValue?.modifierFlagsString, let keycode = m_masShortcut.shortcutValue?.keyCodeString {
            shortcutString = self.getShortCutString(shortCut: flags)+keycode
        }
        
        PopoverController.sharedInstance().showPopover(sender: self)
        defaults.set(shortcutString, forKey: DEFINE_KEY.shortCutStringKey.rawValue)
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
