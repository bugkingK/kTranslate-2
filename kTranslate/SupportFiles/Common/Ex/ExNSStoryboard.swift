//
//  ExNSStoryboard.swift
//  kTranslate
//
//  Created by moon on 05/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

extension NSStoryboard {
    static func make(sbName:String, vcName:String) -> Any {
        return NSStoryboard.init(name: sbName, bundle: nil).instantiateController(withIdentifier: vcName)
    }
    
    static func make(sbName:String) -> Any? {
        return NSStoryboard.init(name: sbName, bundle: nil).instantiateInitialController()
    }
    
}
