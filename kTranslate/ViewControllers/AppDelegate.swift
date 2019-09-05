//
//  AppDelegate.swift
//  AirPodsManager
//
//  Created by moon on 05/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa
import GoogleAnalyticsTracker

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        UserDefaults.standard.DEFINE_Clear()
        MPGoogleAnalyticsTracker.activate(.init(analyticsIdentifier: "UA-141906441-2"))
        
        self.initUserDefaultKey()
        self.showWelcome()
        
        PopoverController.sharedInstance()
        HotKeyManager.shared.registerHotKey()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        UserDefaults.standard.synchronize()
    }
    
    private func initUserDefaultKey(_ force:Bool = false) {
        let defaults = UserDefaults.standard
        let initKey = defaults.bool(forKey: UserKey.initKey.rawValue)
        
        if initKey {
            MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.root, action: AnalyticsAction.launch, label: AnalyticsLabel.existing, value: 0)
            return
        }
        
        defaults.set(true, forKey: UserKey.initKey.rawValue)
        defaults.set(0, forKey: UserKey.domainKey.rawValue)
        defaults.set("400", forKey: UserKey.widthKey.rawValue)
        defaults.set("600", forKey: UserKey.heightKey.rawValue)
        defaults.set("200", forKey: UserKey.menuWidthKey.rawValue)
        defaults.set(false, forKey: UserKey.alwaysShowKey.rawValue)
        defaults.set("set any shortcut", forKey: UserKey.shortCutStringKey.rawValue)
        
        let add_site_name:[String] = ["Kakao", "Papago", "Naver Dic", "Daum Dic", ""]
        let arr_site_address:[String] = ["https://m.translate.kakao.com/", "https://papago.naver.com/", "https://endic.naver.com/", "http://small.dic.daum.net/", ""]
        
        defaults.set(add_site_name, forKey: UserKey.siteNameKey.rawValue)
        defaults.set(arr_site_address, forKey: UserKey.siteAddressKey.rawValue)
        UserDefaults.standard.synchronize()
        MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.root, action: AnalyticsAction.launch, label: AnalyticsLabel.new, value: 0)
    }
    
    private func showWelcome() {
        // defaultValue false
        let isShowWelcome = UserDefaults.standard.bool(forKey: UserKey.welcomeKey.rawValue)
        if !isShowWelcome {
            UserDefaults.standard.set(true, forKey: UserKey.welcomeKey.rawValue)
            UserDefaults.standard.synchronize()
            
            guard let vc = NSStoryboard.init(name: "Settings", bundle: nil).instantiateController(withIdentifier: "Settings_Window") as? NSWindowController else {
                return
            }
            vc.window?.level = .modalPanel
            vc.showWindow(self)
            
        }
    }

}

