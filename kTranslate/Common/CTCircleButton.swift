//
//  CTCircleButton.swift
//  kTranslate
//
//  Created by moon on 13/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

class CTCircleButton: NSButton {
    
    @IBInspectable var borderColor: NSColor?
    @IBInspectable var borderWidth: CGFloat = 0
    @IBInspectable var bgColor: NSColor?
    @IBInspectable var textColor: NSColor?
    @IBInspectable var isDisableBgColor: NSColor?
    
//    override var isEnabled: Bool {
//        didSet(value) {
//            if !isEnabled {
//                self.layer?.backgroundColor = isDisableBgColor?.cgColor
////                self.setNeedsDisplay()
//            } else {
//                self.layer?.backgroundColor = bgColor?.cgColor
////                self.setNeedsDisplay()
//            }
//        }
//    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        self.layer?.cornerRadius = self.frame.height / 2
        self.layer?.borderWidth = borderWidth
        self.layer?.borderColor = borderColor?.cgColor
        self.layer?.backgroundColor = isEnabled ? bgColor?.cgColor : isDisableBgColor?.cgColor
        
    }
    
    override func awakeFromNib() {
        if let textColor = textColor, let font = font {
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            
            let attributes = [
                    NSAttributedString.Key.foregroundColor: textColor,
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.paragraphStyle: style
                    ] as [NSAttributedString.Key : Any]
            
            let attributedTitle = NSAttributedString(string: title, attributes: attributes)
            self.attributedTitle = attributedTitle
        }
    }
}
