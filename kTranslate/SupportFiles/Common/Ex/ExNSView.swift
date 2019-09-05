//
//  ExNSView.swift
//  kTranslate
//
//  Created by moon on 05/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

extension NSView {
    /// UIView가 속해있는 ViewController를 가져옴
    func findViewController() -> NSViewController? {
        if let nextResponder = self.nextResponder as? NSViewController {
            return nextResponder
        } else if let nextResponder = self.nextResponder as? NSView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
