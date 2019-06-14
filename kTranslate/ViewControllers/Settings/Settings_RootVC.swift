//
//  Settings_RootVC.swift
//  kTranslate
//
//  Created by moon on 14/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

class Settings_RootVC: NSViewController, NSWindowDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.delegate = self
    }
    
    func windowWillClose(_ notification: Notification) {
        let b_dontShow = UserDefaults.standard.bool(forKey: UserDefaults_DEFINE_KEY.dontShowKey.rawValue)
        
        if !b_dontShow {
            
            CommonUtil.alertMessageWithKeep("kTranslate will continue to run in the background", "Do not show this message agin") {
                UserDefaults.standard.set(true, forKey: UserDefaults_DEFINE_KEY.dontShowKey.rawValue)
            }
        }
    }
    
}
