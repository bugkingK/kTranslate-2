//
//  Settings_Preferences.swift
//  LogiAppManager-v2
//
//  Created by moon on 10/06/2019.
//  Copyright © 2019 banaple. All rights reserved.
//

import Cocoa
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
    
    private var m_arrSiteName:[String] = {
        return UserDefaults.standard.array(forKey: UserKey.siteNameKey.rawValue) as! [String]
    }()
    private var m_arrSiteAddress:[String] = {
        return UserDefaults.standard.array(forKey: UserKey.siteAddressKey.rawValue) as! [String]
    }()
    
    private func setupLayout() {
        let defaults = UserDefaults.standard
        
        let bAutoLogin:Bool = AutoLogin.enabled
        m_btnAutoLogin.target = self
        m_btnAutoLogin.action = #selector(toggleAutostart(_:))
        m_btnAutoLogin.state = bAutoLogin ? .on : .off
        
        let bool_welcome = defaults.bool(forKey: UserKey.welcomeKey.rawValue)
        m_btnWelcome.target = self
        m_btnWelcome.action = #selector(toggleWelcome(_:))
        m_btnWelcome.state = bool_welcome ? .on : .off
        
        var v_width = defaults.string(forKey: UserKey.widthKey.rawValue)
        if v_width == nil {
            defaults.set("400", forKey: UserKey.widthKey.rawValue)
            v_width = "400"
        }
        
        var v_height = defaults.string(forKey: UserKey.heightKey.rawValue)
        if v_height == nil {
            defaults.set("400", forKey: UserKey.heightKey.rawValue)
            v_height = "600"
        }
        
        var v_menu_width = defaults.string(forKey: UserKey.menuWidthKey.rawValue)
        if v_menu_width == nil {
            defaults.set("200", forKey: UserKey.menuWidthKey.rawValue)
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
        UserDefaults.standard.set(sender.state == .on, forKey: UserKey.welcomeKey.rawValue)
    }
    
    @objc private func onClickWindowSize(_ sender:NSComboBox) {
        guard let str_size = sender.objectValueOfSelectedItem as? String, let int_size = Int(str_size) else {
            return
        }
        
        var key = ""
            switch sender.tag {
            case 0:
                key = UserKey.widthKey.rawValue
            case 1:
                key = UserKey.heightKey.rawValue
            case 2:
                key = UserKey.menuWidthKey.rawValue
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
            UserDefaults.standard.set(self.m_arrSiteName, forKey: UserKey.siteNameKey.rawValue)
        case 5..<10:
            self.m_arrSiteAddress[tag-5] = value
            UserDefaults.standard.set(self.m_arrSiteAddress, forKey: UserKey.siteAddressKey.rawValue)
        default: break
        }
    }
}

extension Settings_Preferences: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        let defaults = UserDefaults.standard
        let b_dontShow = defaults.bool(forKey: UserKey.dontShowKey.rawValue)
        var shortcutString = "set any shortcut"
        
        if !b_dontShow {
            CommonUtil.alertMessageWithKeep("kTranslate will continue to run in the background", "Do not show this message agin") {
                defaults.set(true, forKey: UserKey.dontShowKey.rawValue)
            }
        }
        
        if let flags = m_masShortcut.shortcutValue?.modifierFlagsString, let keycode = m_masShortcut.shortcutValue?.keyCodeString {
            shortcutString = self.getShortCutString(shortCut: flags)+keycode
        }
        
        PopoverController.shared.showPopover(sender: self)
//        guard let vc_main = PopoverController.shared.getLeftViewController() as? MainPopOverVC else {
//            return
//        }
//        defaults.set(shortcutString, forKey: UserKey.shortCutStringKey.rawValue)
//        vc_main.onChangeShortcutButton(shortCut: shortcutString)
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
