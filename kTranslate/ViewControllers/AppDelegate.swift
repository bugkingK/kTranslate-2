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
        let initKey = defaults.bool(forKey: DEFINE_KEY.initKey.rawValue)
        
        if initKey {
            MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.root, action: AnalyticsAction.launch, label: AnalyticsLabel.existing, value: 0)
            return
        }
        
        defaults.set(true, forKey: DEFINE_KEY.initKey.rawValue)
        defaults.set(0, forKey: DEFINE_KEY.domainKey.rawValue)
        defaults.set("400", forKey: DEFINE_KEY.widthKey.rawValue)
        defaults.set("600", forKey: DEFINE_KEY.heightKey.rawValue)
        defaults.set("200", forKey: DEFINE_KEY.menuWidthKey.rawValue)
        defaults.set(false, forKey: DEFINE_KEY.alwaysShowKey.rawValue)
        defaults.set("set any shortcut", forKey: DEFINE_KEY.shortCutStringKey.rawValue)
        
        let add_site_name:[String] = ["Kakao", "Papago", "Naver Dic", "Daum Dic", ""]
        let arr_site_address:[String] = ["https://m.translate.kakao.com/", "https://papago.naver.com/", "https://endic.naver.com/", "http://small.dic.daum.net/", ""]
        
        defaults.set(add_site_name, forKey: DEFINE_KEY.siteNameKey.rawValue)
        defaults.set(arr_site_address, forKey: DEFINE_KEY.siteAddressKey.rawValue)
        UserDefaults.standard.synchronize()
        MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.root, action: AnalyticsAction.launch, label: AnalyticsLabel.new, value: 0)
    }
    
    private func showWelcome() {
        // defaultValue false
        let isShowWelcome = UserDefaults.standard.bool(forKey: DEFINE_KEY.welcomeKey.rawValue)
        if !isShowWelcome {
            UserDefaults.standard.set(true, forKey: DEFINE_KEY.welcomeKey.rawValue)
            UserDefaults.standard.synchronize()
            
            guard let vc = NSStoryboard.init(name: "Settings", bundle: nil).instantiateController(withIdentifier: "Settings_Window") as? NSWindowController else {
                return
            }
            vc.window?.level = .modalPanel
            vc.showWindow(self)
            
        }
    }

}

