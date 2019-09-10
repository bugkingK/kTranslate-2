//
//  Setting_Preference.swift
//  kTranslate
//
//  Created by bugking on 06/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift
import MASShortcut

class Setting_Preference: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setupLayout()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.delegate = self
    }
    
    @IBOutlet weak var m_btn_auto_login: NSButton!
    @IBOutlet weak var m_cb_width: NSComboBox!
    @IBOutlet weak var m_cb_height: NSComboBox!
    @IBOutlet weak var m_vw_shortcut: MASShortcutView!
    @IBOutlet weak var m_st_translator: NSStackView!
    
    fileprivate let m_dispose_bag:DisposeBag = DisposeBag()
    
    fileprivate func setupLayout() {
        m_btn_auto_login.state = AutoLogin.enabled ? .on : .off
        m_btn_auto_login.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                AutoLogin.enabled = self.m_btn_auto_login.state == .on
            })
            .disposed(by: m_dispose_bag)
        
        var cbWidth = UserDefault.string(forKey: .sWidth)
        if cbWidth == nil {
            UserDefault.set("400", key: .sWidth)
            cbWidth = "400"
        }
        m_cb_width.selectItem(withObjectValue: cbWidth)
        m_cb_width.rx.controlEvent
            .subscribe(onNext: { [unowned self] _ in
                guard let str_size = self.m_cb_width.objectValueOfSelectedItem as? String,
                      let int_size = Int(str_size) else {
                    return
                }
                UserDefault.set(int_size, key: .sWidth)
            })
            .disposed(by: m_dispose_bag)
        
        var cbHeight = UserDefault.string(forKey: .sHeight)
        if cbHeight == nil {
            UserDefault.set("600", key: .sHeight)
            cbHeight = "600"
        }
        m_cb_height.selectItem(withObjectValue: cbHeight)
        m_cb_height.rx.controlEvent
            .subscribe(onNext: { _ in
                guard let str_size = self.m_cb_height.objectValueOfSelectedItem as? String,
                    let int_size = Int(str_size) else {
                        return
                }
                UserDefault.set(int_size, key: .sHeight)
            })
            .disposed(by: m_dispose_bag)
        
        for subview in m_st_translator.subviews {
            guard let btn = subview.subviews.first as? NSButton else { continue }
            
            var key: UserDefault.Key = .bTransGoogle
            switch btn.tag {
            case 0: key = .bTransGoogle
            case 1: key = .bTransPapago
            case 2: key = .bTransKakao
            case 3: key = .bTranskTranslate
            default: break
            }
            
            let state = UserDefault.bool(forKey: key)
            btn.state = state ? .on : .off

            btn.rx.tap
                .subscribe(onNext: { _ in
                    let state = btn.state == .on
                    UserDefault.set(state, key: key)
                }).disposed(by: m_dispose_bag)
        }
        
        HotKeyManager.shared.registerHotKey(shortcutView: m_vw_shortcut)
    }
    
}

extension Setting_Preference: NSWindowDelegate {
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        var shortcutString = "set any shortcut"
        if let flags = m_vw_shortcut.shortcutValue?.modifierFlagsString, let keycode = m_vw_shortcut.shortcutValue?.keyCodeString {
            shortcutString = HotKeyManager.getShortCutString(shortCut: flags)+keycode
        }
        
        UserDefault.set(shortcutString, key: .sShortCutKey)
        PopoverController.shared.showPopover(sender: self)
        return true
    }
    
    
}
