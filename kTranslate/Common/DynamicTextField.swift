//
//  DynamicTextField.swift
//  kTranslate
//
//  Created by moon on 18/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

public class DynamicTextField: NSTextField {
    public override var intrinsicContentSize: NSSize {
        if cell!.wraps {
            // Create bounds with a fictional height
            let fictionalBounds = NSRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
            return cell!.cellSize(forBounds: fictionalBounds)
        } else {
            return super.intrinsicContentSize
        }
    }
    
    public override func textDidChange(_ notification: Notification) {
        super.textDidChange(notification)
        
        if cell!.wraps {
            // Update the backing store from the Field Editor
            validateEditing()
            invalidateIntrinsicContentSize()
        }
    }
}

