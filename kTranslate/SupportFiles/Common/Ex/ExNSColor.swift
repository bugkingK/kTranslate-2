//
//  ExNSColor.swift
//  kTranslate
//
//  Created by moon on 05/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

extension NSColor {
    /// (RGB-34,36,40) 글자 색
    static let hex_222428:NSColor = .init(hexFromString: "#222428")
    /// (RGB-238,118,138) 버튼 색, 번역 + 언어선택할 때 사용
    static let hex_EE768A:NSColor = .init(hexFromString: "#ee768a")
    /// (RGB-247,247,247) 채팅 창 배경 색
    static let hex_F7F7F7:NSColor = .init(hexFromString: "#f7f7f7")
}




extension NSColor {
    // hexFromString
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    var hexString: String {
        guard let rgbColor = usingColorSpaceName(NSColorSpaceName.calibratedRGB) else {
            return "FFFFFF"
        }
        let red = Int(round(rgbColor.redComponent * 0xFF))
        let green = Int(round(rgbColor.greenComponent * 0xFF))
        let blue = Int(round(rgbColor.blueComponent * 0xFF))
        let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
        return hexString as String
    }
}
