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
    case welcomeKey = "WelcomeKey"
    case dontShowKey = "DontShowKey"
    
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
    static let launch = "Launch"
    static let popover = "Popover"
    static let preference = "Preference"
    static let about = "About"
}

struct AnalyticsAction {
    static let new = "New User"
    static let existing = "Existing User"
    static let open = "Open"
    static let close = "Close"
    static let translator = "Translator" // Use `DictionaryName` as Label
    static let search = "Search"
    static let updateHotKey = "UpdateHotKey"
    static let checkForUpdate = "CheckForUpdate"
    static let viewOnGitHub = "ViewOnGitHub"
    static let openEmail = "OpenEmail"
    static let viewOnPage = "ViewOnPage"
}

struct AnalyticsLabel {
    static let english = "English"
    static let korean = "Korean"
    static let hanja = "Hanja"
    static let japanese = "Japanese"
    static let chinese = "Chinese"
    static let french = "French"
    static let russian = "Russian"
    static let spanish = "Spanish"
}
