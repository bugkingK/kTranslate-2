//
//  CustomButton.swift
//  kTranslate
//
//  Created by bugking on 02/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa
import GoogleAnalyticsTracker

class CustomButton:NSButton {
    
    public var actionKey:String?
    
    override func sendAction(_ action: Selector?, to target: Any?) -> Bool {
        if let v_actionKey = actionKey {
            MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.root, action:v_actionKey, label: "", value: 0)
        }
        
        return super.sendAction(action, to: target)
    }
}
