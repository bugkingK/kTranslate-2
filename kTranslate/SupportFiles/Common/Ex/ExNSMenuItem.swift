//
//  ExNSMenuItem.swift
//  kTranslate
//
//  Created by bugking on 05/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

extension NSMenuItem {
    static func make(_ title:String, _ target:AnyObject?, _ action:Selector?, _ keyEquivalent:String) -> NSMenuItem {
        let v = NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent)
        v.target = target
        return v
    }
    
    static func make(_ title:String, _ keyEquivalent:String, _ block:(()->())?) -> NSMenuItem {
        m_block = block
        let v = NSMenuItem(title: title, action: #selector(m_action), keyEquivalent: keyEquivalent)
        v.target = self
        return v
    }
    
    static var m_block:(()->())?
    @objc static func m_action() {
        m_block?()
    }
}

extension NSMenu {
    func addItems(_ items:[NSMenuItem]) {
        for item in items {
            self.addItem(item)
        }
    }
}
