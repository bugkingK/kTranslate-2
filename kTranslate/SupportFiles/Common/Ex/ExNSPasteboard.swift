//
//  ExNSPasteboard.swift
//  kTranslate
//
//  Created by bugking on 07/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

extension NSPasteboard {
    func clipboardContent() -> String?
    {
        return NSPasteboard.general.pasteboardItems?.first?.string(forType: .string)
    }
}
