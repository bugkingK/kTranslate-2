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

enum UserDefaults_DEFINE_KEY:String, CaseIterable {
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
}


extension UserDefaults {
    func DEFINE_Clear() {
        _ = UserDefaults_DEFINE_KEY.allCases.map {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}


struct TranslatorURL {
    static let kakaoURL:URL = URL(string: "https://m.translate.kakao.com/")!
    static let papagoURL:URL = URL(string: "https://papago.naver.com/")!
    static let googleURL:URL = URL(string: "https://translate.google.co.kr/")!
    static let betterURL:URL = URL(string: "http://better-translator.com/")!
}

struct AnalyticsCategory {
    static let kTranslate = "kTranslate"
    static let preference = "Preference"
    static let about = "About"
}

struct AnalyticsAction {
    static let itself = "Itself"
    
    // kTranslate
    static let launch = "Launch"
    static let popover = "Popover"
    static let mTranslator = "Mtranslator"
    static let alwaysShow = "AlwaysShow"
    
    // preference
    static let dTranslator = "Dtranslator"
    static let size = "Size"
    static let shortCut = "ShortCut"
    
    // about
    static let mail = "Mail"
    static let github = "Github"
    static let page = "Page"
}

struct AnalyticsLabel {
    static let google = "Google"
    static let papago = "Papago"
    static let kakao = "Kakao"
    
    // kTranslate
    static let new = "New"
    static let existing = "Existing"
    static let open = "Open"
    static let close = "Close"
}
