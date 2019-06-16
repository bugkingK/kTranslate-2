//
//  CTWindowController.swift
//  kTranslate
//
//  Created by bugking on 11/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

class CTWindowController: NSWindowController, NSWindowDelegate {

    var contentView: NSView {
        get {
            return self.window!.contentView!
        }
        set {
            self.window!.contentView = newValue
        }
    }
    
    init(windowSize: CGSize = CGSize.zero) {
        let screenSize = NSScreen.main!.frame.size
        let rect = CGRect(
            x: (screenSize.width - windowSize.width) / 2,
            y: (screenSize.height - windowSize.height) / 2,
            width: windowSize.width,
            height: windowSize.height
        )
        let mask: NSWindow.StyleMask = [.titled, .closable]
        let window = NSWindow(contentRect: rect, styleMask: mask, backing: .buffered, defer: false)
        super.init(window: window)
        
        window.delegate = self
        window.hasShadow = true
        window.contentView = NSView()
    }
    
    override init(window: NSWindow?) {
        window?.styleMask = [.titled, .closable]
        window?.backingType = .buffered
        super.init(window: window)
        window?.delegate = self
        window?.hasShadow = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func showWindow(_ sender: Any?) {
        PopoverController.sharedInstance().closePopover(sender: sender)
        super.showWindow(sender)
        self.window?.level = .floating
        self.window?.makeKeyAndOrderFront(sender)
    }
}
