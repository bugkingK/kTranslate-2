//
//  ExUserDefaults.swift
//  kTranslate
//
//  Created by moon on 05/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Foundation

class UserDefault {
    enum Key:String, CaseIterable {
        /// Popover Always
        case bLaunchInit = "bLaunchInit"
        case bAlways = "bAlways"
        case sWidth = "sWidth"
        case sHeight = "sHeight"
        case sShortCutKey = "sShortCutKey"
        
        case bTransGoogle = "sTransGoogle"
        case bTransPapago = "bTransPapago"
        case bTransKakao = "bTransKakao"
        case bTranskTranslate = "bTranskTranslate"
    }
    
    static func set(_ value:Any?, key:Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func bool(forKey:Key) -> Bool {
        return UserDefaults.standard.bool(forKey: forKey.rawValue)
    }
    
    static func integer(forKey:Key) -> Int {
        return UserDefaults.standard.integer(forKey: forKey.rawValue)
    }
    
    static func string(forKey:Key) -> String? {
        return UserDefaults.standard.string(forKey: forKey.rawValue)
    }
    
    static func cgfloat(forKey:Key) -> CGFloat {
        return CGFloat(UserDefaults.standard.float(forKey: forKey.rawValue))
    }
    
    static func dictionary(forKey:Key) -> Dictionary<String, Any>? {
        return UserDefaults.standard.dictionary(forKey: forKey.rawValue)
    }
    
    static func clear() {
        _ = Key.allCases.map {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}

