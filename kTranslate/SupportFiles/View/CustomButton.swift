//
//  CustomButton.swift
//  Translate-Text
//
//  Created by moon on 03/09/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import Cocoa

class CustomButton: NSButton {
    
    @IBInspectable var backgroundColor:NSColor = .white {
        didSet {
            (self.cell as! NSButtonCell).backgroundColor = backgroundColor
        }
    }
    @IBInspectable var borderColor:NSColor = .white
    @IBInspectable var borderWidth:CGFloat = 0
    @IBInspectable var cornerRadius:CGFloat = 0
    @IBInspectable var textColor:NSColor = .black
    
    override var title: String {
        didSet {
            let myAttribute = [NSAttributedString.Key.foregroundColor: textColor ]
            let myAttrString = NSAttributedString(string: title, attributes: myAttribute)
            self.attributedTitle = myAttrString
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if cornerRadius > 0 {
            self.layer?.masksToBounds = true
            self.layer?.cornerRadius = cornerRadius
            self.layer?.borderColor = borderColor.cgColor
            self.layer?.borderWidth = borderWidth
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        (self.cell as! NSButtonCell).isBordered = false
        (self.cell as! NSButtonCell).backgroundColor = backgroundColor
        
        let myAttribute = [NSAttributedString.Key.foregroundColor: textColor ]
        let myAttrString = NSAttributedString(string: self.cell?.title ?? "", attributes: myAttribute)
        (self.cell as! NSButtonCell).attributedTitle = myAttrString
    }
    
}
