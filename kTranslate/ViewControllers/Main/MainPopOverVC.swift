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
        m_wvMain.editingDelegate = self
        
        self.m_btnA.target = self
        self.m_btnA.action = #selector(onClickAlwayShow(_:))
        let bAlways = UserDefaults.standard.bool(forKey: UserDefaults_DEFINE_KEY.alwaysShowKey.rawValue)
        self.m_btnA.state = bAlways ? .on : .off
        
        self.m_btnShortCut.target = self
        self.m_btnShortCut.action = #selector(onPreperences)
        self.m_arrBtnCircle = [m_btnG, m_btnP, m_btnK]
        for btn in self.m_arrBtnCircle {
            btn.target = self
            btn.action = #selector(onChangeTranslate(_:))
        }
        
        self.initMenu()
        
        let idx = UserDefaults.standard.integer(forKey: UserDefaults_DEFINE_KEY.domainKey.rawValue)
        self.loadWebTranslate(idx: idx)
        guard let initShortCutString = UserDefaults.standard.string(forKey: UserDefaults_DEFINE_KEY.shortCutStringKey.rawValue) else {
            self.onChangeShortcutButton(shortCut: "")
            return
        }
        self.onChangeShortcutButton(shortCut: initShortCutString)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        let width = UserDefaults.standard.integer(forKey: UserDefaults_DEFINE_KEY.widthKey.rawValue)
        let height = UserDefaults.standard.integer(forKey: UserDefaults_DEFINE_KEY.heightKey.rawValue)
        
        m_lyContentWidth.constant = CGFloat(width)
        m_lyContentHeight.constant = CGFloat(height)
    }
    
    private func initMenu() {
        let root_menu = NSMenu()
        let arr_menu_items = [
            NSMenuItem(title: "About kTranslate", action: #selector(onAbout), keyEquivalent: ""),
            NSMenuItem(title: "Preperences..", action: #selector(onPreperences), keyEquivalent: ","),
            NSMenuItem.separator(),
            NSMenuItem(title: "translator change", action: nil, keyEquivalent: ""),
            NSMenuItem.separator(),
            NSMenuItem(title: "Quit", action: #selector(onQuit), keyEquivalent: "q")
        ]
        
        let arr_trans:[NSMenuItem] = [
            NSMenuItem(title: "Google Translator", action: #selector(onChangeTranslate(_:)), keyEquivalent: "1"),
            NSMenuItem(title: "Papago Translator", action: #selector(onChangeTranslate(_:)), keyEquivalent: "2"),
            NSMenuItem(title: "Kako Translator", action: #selector(onChangeTranslate(_:)), keyEquivalent: "3")
        ]
        
        let chg_menu = NSMenu()
        for (idx, trans) in arr_trans.enumerated() {
            trans.target = self
            trans.tag = idx
            chg_menu.addItem(trans)
        }
        
        arr_menu_items[3].submenu = chg_menu
        for item in arr_menu_items {
            item.target = self
            root_menu.addItem(item)
        }
        m_side_menu = root_menu
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
    
    private var m_side_menu: NSMenu!
    private var m_arrBtnCircle:[CTCircleButton] = []
    private let m_wvMain:WebView = {
        let wv = WebView()
        wv.shouldUpdateWhileOffscreen = true
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()
    
    public func onChangeShortcutButton(shortCut:String) {
        m_btnShortCut.title = shortCut
    }
    
    @objc public func onChangeTranslate(_ sender: AnyObject) {
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
    
    @objc private func onQuit() {
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
    
    @IBAction func onClickBtnMenu(_ sender: NSButton) {
        PopoverController.sharedInstance().toggleMemoMenu(isShow: sender.state == .on)
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

extension MainPopOverVC: WebEditingDelegate {
//
//    func webView(_ webView: WebView!, shouldChangeSelectedDOMRange currentRange: DOMRange!, to proposedRange: DOMRange!, affinity selectionAffinity: NSSelectionAffinity, stillSelecting flag: Bool) -> Bool {
//
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
//            let script_outer = "document.getElementsByClassName('tlid-translation translation')[0].innerText"
//            let script_inner = "document.getElementsByClassName('text-dummy')[0].textContent"
//            if let innerText = self.m_wvMain.stringByEvaluatingJavaScript(from: script_inner), let outerText = self.m_wvMain.stringByEvaluatingJavaScript(from: script_outer) {
//
//                if innerText != "" {
//                    print(innerText)
//                }
//
//                if outerText != "" {
//                    print(outerText)
//                }
//
//            }
//        }
//
//        return true
//    }
//
//    func webView(_ webView: WebView!, shouldInsertText text: String!, replacing range: DOMRange!, given action: WebViewInsertAction) -> Bool {
//
//
//        return true
//    }
//
//    func webViewDidChange(_ notification: Notification!) {
//
//    }
}


