//
//  Popup_Viewer.swift
//  kTranslate
//
//  Created by moon on 10/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

class Popup_Viewer: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.title = "Viewer"
        m_img_viewer.image = m_img
    }
    
    @IBOutlet weak var m_img_viewer: NSImageView!
    fileprivate var m_img:NSImage?
    
    static func shared() -> Popup_Viewer {
        return NSStoryboard.make(sbName: "Popup", vcName: "Popup_Viewer") as! Popup_Viewer
    }
    
    func setupImage(_ image:NSImage?) -> Popup_Viewer {
        self.m_img = image
        return self
    }
    
    func show(_ target:NSViewController?) {
        target?.presentAsModalWindow(self)
    }
    
}
