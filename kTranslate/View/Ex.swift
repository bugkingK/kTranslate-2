//
//  Ex.swift
//  kTranslate
//
//  Created by bugking on 02/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

extension NSStoryboard {
    static func showStoryboard(sbName:String, vcName:String) {
        let vc = NSStoryboard(name: sbName, bundle: nil).instantiateController(withIdentifier: vcName) as! NSViewController
        let windowVC = CTWindowController(window: NSWindow(contentViewController: vc))
        windowVC.showWindow(nil)
    }
}

extension NSMenuItem {
    static func make(title:String, target:AnyObject, action:Selector?, keyEquivalent:String) -> NSMenuItem{
        let item = NSMenuItem(title: title, action: action, keyEquivalent: keyEquivalent)
        item.target = target
        return item
    }
}

extension NSMenu {
    func addItems(_ items:[NSMenuItem]) {
        for item in items {
            self.addItem(item)
        }
    }
}
