//
//  CTContainerViewController.swift
//  Project-Manager
//
//  Created by moon on 25/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

class CTContainerViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBOutlet weak var vwContain:NSView?
    public var vcCurrent:NSViewController?
    
    public func removeViewController() {
        vcCurrent?.view.removeFromSuperview()
        vcCurrent?.removeFromParent()
    }
    
    public func bindToViewController(targetVC:NSViewController) {
        guard let v_vwContain = vwContain else {
            return
        }
        if vcCurrent != nil {
            self.removeViewController()
        }
        
        self.addChild(targetVC)
        v_vwContain.addSubview(targetVC.view)
        
        targetVC.view.translatesAutoresizingMaskIntoConstraints = false
        targetVC.view.leadingAnchor.constraint(equalTo: v_vwContain.leadingAnchor).isActive = true
        targetVC.view.trailingAnchor.constraint(equalTo: v_vwContain.trailingAnchor).isActive = true
        targetVC.view.topAnchor.constraint(equalTo: v_vwContain.topAnchor).isActive = true
        targetVC.view.bottomAnchor.constraint(equalTo: v_vwContain.bottomAnchor).isActive = true
        
        vcCurrent = targetVC
    }
}
