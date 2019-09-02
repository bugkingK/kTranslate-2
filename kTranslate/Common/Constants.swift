//
//  Constants.swift
//  kTranslate
//
//  Created by moon on 14/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

struct BundleInfo {
    static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    static let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
    static let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as! String
}

enum DEFINE_KEY:String, CaseIterable {
    case initKey = "init"
    case domainKey = "number_translate_domain"
    case widthKey = "WidthKey"
    case heightKey = "HeightKey"
    case menuWidthKey = "MenuWidthKey"
    case welcomeKey = "WelcomeKey"
    case dontShowKey = "DontShowKey"
    case alwaysShowKey = "AlwaysShowKey"
    case initShortcut = "InitShortcut"
    case shortCutStringKey = "ShortCutStringKey"
    case siteNameKey = "SiteNameKey"
    case siteAddressKey = "SiteAddressKey"
}


extension UserDefaults {
    func DEFINE_Clear() {
        _ = DEFINE_KEY.allCases.map {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}

struct AnalyticsCategory {
    static let root = "kTranslate"
    static let preference = "Preference"
    static let about = "About"
}

struct AnalyticsAction {
    static let itself = "Itself"
    
    // kTranslate
    static let launch = "Launch"
    static let popover = "Popover"
    static let alwaysShow = "AlwaysShow"
    static let moveSite = "MoveSite"
    
    // preference
    static let size = "Size"
    static let shortCut = "ShortCut"
    
    // about
    static let mail = "Mail"
    static let github = "Github"
    static let page = "Page"
}

struct AnalyticsLabel {
    // kTranslate
    static let new = "New"
    static let existing = "Existing"
    static let open = "Open"
    static let close = "Close"
}
