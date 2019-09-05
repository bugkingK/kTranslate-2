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
        window?.titlebarAppearsTransparent = true
        super.init(window: window)
        window?.delegate = self
        window?.hasShadow = true
        window?.title = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func showWindow(_ sender: Any?) {
        PopoverController.shared.closePopover(sender: sender)
        super.showWindow(sender)
        self.window?.level = .floating
        self.window?.makeKeyAndOrderFront(sender)
    }
    
    static func showWindow(sbName:String, vcName:String) {
        guard let vc = NSStoryboard.init(name: sbName, bundle: nil).instantiateController(withIdentifier: vcName) as? NSViewController else {
            return
        }
        let windowVC = CTWindowController(window: NSWindow(contentViewController: vc))
        windowVC.showWindow(self)
    }
}
