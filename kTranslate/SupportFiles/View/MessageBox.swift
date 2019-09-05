//
//  MessageBox.swift
//  Translate-Text
//
//  Created by bugking on 04/09/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import Cocoa

class MessageBox: NSBox {
    
    @IBInspectable var isIncoming:Bool = false
    @IBInspectable var incomingColor:NSColor = NSColor(white: 0.9, alpha: 1)
    @IBInspectable var outgoingColor:NSColor = NSColor(red: 0.09, green: 0.54, blue: 1, alpha: 1)

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.drawMessageBox(rect: dirtyRect)
    }
    
    func drawMessageBox(rect:NSRect) {
        let width = rect.width
//        let height = rect.height
        let height = self.frame.maxY-10
        
        let bezierPath = NSBezierPath()
        
        if isIncoming {
            bezierPath.move(to: CGPoint(x: 22, y: height))
            bezierPath.line(to: CGPoint(x: width - 17, y: height))
            bezierPath.curve(to: CGPoint(x: width, y: height - 17), controlPoint1: CGPoint(x: width - 7.61, y: height), controlPoint2: CGPoint(x: width, y: height - 7.61))
            bezierPath.line(to: CGPoint(x: width, y: 17))
            bezierPath.curve(to: CGPoint(x: width - 17, y: 0), controlPoint1: CGPoint(x: width, y: 7.61), controlPoint2: CGPoint(x: width - 7.61, y: 0))
            bezierPath.line(to: CGPoint(x: 21, y: 0))
            bezierPath.curve(to: CGPoint(x: 4, y: 17), controlPoint1: CGPoint(x: 11.61, y: 0), controlPoint2: CGPoint(x: 4, y: 7.61))
            bezierPath.line(to: CGPoint(x: 4, y: height - 11))
            bezierPath.curve(to: CGPoint(x: 0, y: height), controlPoint1: CGPoint(x: 4, y: height - 1), controlPoint2: CGPoint(x: 0, y: height))
            bezierPath.line(to: CGPoint(x: -0.05, y: height - 0.01))
            bezierPath.curve(to: CGPoint(x: 11.04, y: height - 4.04), controlPoint1: CGPoint(x: 4.07, y: height + 0.43), controlPoint2: CGPoint(x: 8.16, y: height - 1.06))
            bezierPath.curve(to: CGPoint(x: 22, y: height), controlPoint1: CGPoint(x: 16, y: height), controlPoint2: CGPoint(x: 19, y: height))
            
            incomingColor.setFill()
            
        } else {
            bezierPath.move(to: CGPoint(x: width - 22, y: height))
            bezierPath.line(to: CGPoint(x: 17, y: height))
            bezierPath.curve(to: CGPoint(x: 0, y: height - 17), controlPoint1: CGPoint(x: 7.61, y: height), controlPoint2: CGPoint(x: 0, y: height - 7.61))
            bezierPath.line(to: CGPoint(x: 0, y: 17))
            bezierPath.curve(to: CGPoint(x: 17, y: 0), controlPoint1: CGPoint(x: 0, y: 7.61), controlPoint2: CGPoint(x: 7.61, y: 0))
            bezierPath.line(to: CGPoint(x: width - 21, y: 0))
            bezierPath.curve(to: CGPoint(x: width - 4, y: 17), controlPoint1: CGPoint(x: width - 11.61, y: 0), controlPoint2: CGPoint(x: width - 4, y: 7.61))
            bezierPath.line(to: CGPoint(x: width - 4, y: height - 11))
            bezierPath.curve(to: CGPoint(x: width, y: height), controlPoint1: CGPoint(x: width - 4, y: height - 1), controlPoint2: CGPoint(x: width, y: height))
            bezierPath.line(to: CGPoint(x: width + 0.05, y: height - 0.01))
            bezierPath.curve(to: CGPoint(x: width - 11.04, y: height - 4.04), controlPoint1: CGPoint(x: width - 4.07, y: height + 0.43), controlPoint2: CGPoint(x: width - 8.16, y: height - 1.06))
            bezierPath.curve(to: CGPoint(x: width - 22, y: height), controlPoint1: CGPoint(x: width - 16, y: height), controlPoint2: CGPoint(x: width - 19, y: height))
            
            outgoingColor.setFill()
        }
        
        bezierPath.close()
        bezierPath.fill()
    }
}
