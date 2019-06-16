//
//  MainPopOverVC.swift
//  AirPodsManager
//
//  Created by moon on 05/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa
import WebKit
import GoogleAnalyticsTracker

class MainPopOverVC: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        NSApp.activate(ignoringOtherApps: true)
        m_vwWebView.addSubview(m_wvMain)
        m_wvMain.topAnchor.constraint(equalTo: m_vwWebView.topAnchor).isActive = true
        m_wvMain.leadingAnchor.constraint(equalTo: m_vwWebView.leadingAnchor).isActive = true
        m_wvMain.trailingAnchor.constraint(equalTo: m_vwWebView.trailingAnchor).isActive = true
        m_wvMain.bottomAnchor.constraint(equalTo: m_vwWebView.bottomAnchor).isActive = true
        m_wvMain.frameLoadDelegate = self
        
        self.m_btnA.action = #selector(onClickAlwayShow(_:))
        let bAlways = UserDefaults.standard.bool(forKey: UserDefaults_DEFINE_KEY.alwaysShowKey.rawValue)
        self.m_btnA.state = bAlways ? .on : .off
        self.m_btnShortCut.action = #selector(onPreperences)
        self.m_arrBtnCircle = [m_btnG, m_btnP, m_btnK]
        for btn in self.m_arrBtnCircle {
            btn.action = #selector(onChangeTranslate(_:))
        }
        
        let idx = UserDefaults.standard.integer(forKey: UserDefaults_DEFINE_KEY.domainKey.rawValue)
        self.loadWebTranslate(idx: idx)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        let width = UserDefaults.standard.integer(forKey: UserDefaults_DEFINE_KEY.widthKey.rawValue)
        let height = UserDefaults.standard.integer(forKey: UserDefaults_DEFINE_KEY.heightKey.rawValue)
        
        m_lyContentWidth.constant = CGFloat(width)
        m_lyContentHeight.constant = CGFloat(height)
    }
    
    @IBOutlet weak var m_vwWebView: NSView!
    @IBOutlet weak var m_btnShortCut: NSButton!
    @IBOutlet weak var m_indicator: NSProgressIndicator!
    @IBOutlet weak var m_lyContentWidth: NSLayoutConstraint!
    @IBOutlet weak var m_lyContentHeight: NSLayoutConstraint!
    @IBOutlet weak var m_btnG: CTCircleButton!
    @IBOutlet weak var m_btnP: CTCircleButton!
    @IBOutlet weak var m_btnK: CTCircleButton!
    @IBOutlet weak var m_btnA: CTCircleButton!
    
    private var m_arrBtnCircle:[CTCircleButton] = []
    private let m_wvMain:WebView = {
        let wv = WebView()
        wv.shouldUpdateWhileOffscreen = true
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()
    private let m_side_menu: NSMenu = {
        let root_menu = NSMenu()

        root_menu.addItem(NSMenuItem(title: "About kTranslate", action: #selector(onAbout), keyEquivalent: ""))
        root_menu.addItem(NSMenuItem(title: "Preperences..", action: #selector(onPreperences), keyEquivalent: ","))
        root_menu.addItem(NSMenuItem.separator())
        let chg_trans = NSMenuItem(title: "translator change", action: nil, keyEquivalent: "")
        let chg_menu = NSMenu()
        let arr_trans:[NSMenuItem] = [
            NSMenuItem(title: "Google Translator", action: #selector(onChangeTranslate(_:)), keyEquivalent: "1"),
            NSMenuItem(title: "Papago Translator", action: #selector(onChangeTranslate(_:)), keyEquivalent: "2"),
            NSMenuItem(title: "Kako Translator", action: #selector(onChangeTranslate(_:)), keyEquivalent: "3")
        ]

        for (idx, trans) in arr_trans.enumerated() {
            trans.tag = idx
            chg_menu.addItem(trans)
        }
        
        chg_trans.submenu = chg_menu
        root_menu.addItem(chg_trans)
        root_menu.addItem(NSMenuItem.separator())
        root_menu.addItem(NSMenuItem(title: "Exit..", action: #selector(onExit), keyEquivalent: "q"))
        
        return root_menu
    }()
    
    @objc public func onChangeTranslate(_ sender: AnyObject) {
//        UserDefaults.standard.setValue(sender.tag, forKey: UserDefaults_DEFINE_KEY.domainKey.rawValue)
        self.loadWebTranslate(idx: sender.tag)
    }
    
    @objc private func onAbout() {
        guard let vc = NSStoryboard.init(name: "Settings", bundle: nil).instantiateController(withIdentifier: "Settings_About") as? Settings_About else {
            return
        }
        let windowVC = CTWindowController(window: NSWindow(contentViewController: vc))
        windowVC.showWindow(self)
    }
    
    @objc public func onPreperences() {
        guard let vc = NSStoryboard.init(name: "Settings", bundle: nil).instantiateController(withIdentifier: "Settings_Preferences") as? Settings_Preferences else {
            return
        }
        let windowVC = CTWindowController(window: NSWindow(contentViewController: vc))
        windowVC.showWindow(self)
        
        MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.preference, action:AnalyticsAction.itself, label: "", value: 0)
    }
    
    @objc private func onExit() {
        NSApp.terminate(nil)
    }
    
    @objc private func onClickAlwayShow(_ sender:NSButton) {
        UserDefaults.standard.set(sender.state == .on, forKey: UserDefaults_DEFINE_KEY.alwaysShowKey.rawValue)
        MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.kTranslate, action:AnalyticsAction.alwaysShow, label: "", value: 0)
    }
    
    @IBAction private func onClickSideMenu(_ sender: NSButton) {
        let p = NSPoint(x: 0, y: (sender.frame.height*2)-10)
        self.m_side_menu.popUp(positioning: self.m_side_menu.item(at: 0), at: p, in: sender)
    }
    
    private func loadWebTranslate(idx:Int) {
        var url:URL?
        var label:String?
        guard let menu_trans = m_side_menu.item(at: 3)?.submenu else {
            return
        }
        for trans in menu_trans.items {
            trans.state = trans.tag == idx ? .on : .off
        }
        
        for btn in m_arrBtnCircle {
            btn.state = btn.tag == idx ? .on : .off
        }
        
        switch idx {
        case 0:
            url = TranslatorURL.googleURL
            label = AnalyticsLabel.google
        case 1:
            url = TranslatorURL.papagoURL
            label = AnalyticsLabel.papago
        case 2:
            url = TranslatorURL.kakaoURL
            label = AnalyticsLabel.kakao
        default: break
        }
        
        guard let v_url = url else { return }
        let request = URLRequest(url: v_url)
        m_wvMain.mainFrame.load(request)
        MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.preference, action:AnalyticsAction.mTranslator, label: label, value: 0)
    }
    
    private func loadingBar(show:Bool) {
        if show {
            self.m_indicator.isHidden = false
            self.m_indicator.startAnimation(self)
        } else {
            self.m_indicator.isHidden = true
            self.m_indicator.stopAnimation(self)
        }
    }
}

extension MainPopOverVC: WebFrameLoadDelegate {
    func webView(_ sender: WebView!, didFinishLoadFor frame: WebFrame!) {
        self.loadingBar(show: false)
    }
    
    func webView(_ sender: WebView!, didStartProvisionalLoadFor frame: WebFrame!) {
        self.loadingBar(show: true)
    }
}
