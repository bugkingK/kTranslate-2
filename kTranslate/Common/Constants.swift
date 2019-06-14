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

enum UserDefaults_DEFINE_KEY:String {
    case domainKey = "number_translate_domain"
    case frameKey = "frameKey"
}

//@objc class UserDefaultsKey: NSObject {
//    class var ignoreApplicationFolderWarning: String { return "AKIgnoreApplicationFolder" }
//    class var hotKey: String { return "AllkdicSettingKeyHotKey" }
//    class var selectedDictionaryName: String { return "SelectedDictionaryName" }
//}
struct AnalyticsCategory {
    static let kTranslate = "kTranslate"
    static let preference = "Preference"
    static let about = "About"
}

struct AnalyticsAction {
    static let open = "Open"
    static let close = "Close"
    static let dictionary = "Dictionary" // Use `DictionaryName` as Label
    static let search = "Search"
    static let updateHotKey = "UpdateHotKey"
    static let checkForUpdate = "CheckForUpdate"
    static let viewOnGitHub = "ViewOnGitHub"
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
