//
//  PopoverController.swift
//  AirPodsManager
//
//  Created by moon on 11/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

private let _sharedInstance = PopoverController()

open class PopoverController: NSObject {
    fileprivate let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    fileprivate let popover = NSPopover()
    fileprivate var eventMonitor: EventMonitor?
    
    @discardableResult
    open class func sharedInstance() -> PopoverController {
        return _sharedInstance
    }
    
    public override init() {
        super.init()
        
        if let button = self.statusItem.button {
            let icon = NSImage(named: .init("StatusBarButtonImage"))
            icon?.isTemplate = true
            button.image = icon
            button.target = self
            button.action = #selector(togglePopover(_:))
            button.focusRingType = .none
            button.setButtonType(.pushOnPushOff)
        }
        
        guard let vc = NSStoryboard.init(name: "Main", bundle: nil).instantiateController(withIdentifier: "MainPopOverVC") as? NSViewController else {
            return
        }
        popover.contentViewController = vc
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
    }
    
    @objc open func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
}

class EventMonitor: NSObject {
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> Void
    
    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }
    
    public func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
