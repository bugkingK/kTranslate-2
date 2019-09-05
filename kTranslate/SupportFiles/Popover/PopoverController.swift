//
//  PopoverController.swift
//  AirPodsManager
//
//  Created by moon on 11/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

open class PopoverController: NSObject {
    
    static let shared:PopoverController = PopoverController()
    
    fileprivate let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    public let popover = NSPopover()
    fileprivate var eventMonitor: EventMonitor?
    fileprivate var m_event_handler:((NSEvent?)->())?
    
    fileprivate override init() {
        super.init()
        
        if let button = self.statusItem.button {
            button.target = self
            button.action = #selector(togglePopover(_:))
            button.focusRingType = .none
            button.setButtonType(.pushOnPushOff)
        }
    }

    public func setLayout(_ image:String, vc:NSViewController?, event:@escaping ((PopoverController)->())) {
        statusItem.button?.image = NSImage(named: .init(image))
        popover.contentViewController = vc
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { (_) in
            event(self)
        }
    }
    
    @objc open func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    public func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
        }
    }
    
    public func closePopover(sender: Any?) {
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
