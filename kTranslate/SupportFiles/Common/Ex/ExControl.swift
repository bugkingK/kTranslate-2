//
//  ExControl.swift
//  kTranslate
//
//  Created by moon on 05/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

extension NSControl {
    func addTarget(_ target:AnyObject?, action:Selector?) {
        self.target = self
        self.action = action
    }
}
