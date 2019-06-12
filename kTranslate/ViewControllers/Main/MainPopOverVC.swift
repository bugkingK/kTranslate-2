//
//  MainPopOverVC.swift
//  AirPodsManager
//
//  Created by moon on 05/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa
import WebKit

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
        
        let idx = UserDefaults.standard.integer(forKey: UserDefaults_DEFINE_KEY.domainKey.rawValue)
        self.loadWebTranslate(idx: idx)
        self.m_btnHome.action = #selector(onClickHome(_:))
        self.m_btnShortCut.action = #selector(onPreperences)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        let idx_select = UserDefaults.standard.integer(forKey: UserDefaults_DEFINE_KEY.frameKey.rawValue)
        
        switch idx_select {
        case 0:
            m_lyContentWidth.constant = 350
            m_lyContentHeight.constant = 500
        case 1:
            m_lyContentWidth.constant = 450
            m_lyContentHeight.constant = 650
        case 2:
            m_lyContentWidth.constant = 500
            m_lyContentHeight.constant = 700
        case 3:
            m_lyContentWidth.constant = 700
            m_lyContentHeight.constant = 500
        case 4:
            m_lyContentWidth.constant = 1000
            m_lyContentHeight.constant = 700
        default:
            m_lyContentWidth.constant = 350
            m_lyContentHeight.constant = 500
        }
    }
    
    @IBOutlet weak var m_vwWebView: NSView!
    @IBOutlet weak var m_btnHome: NSButton!
    @IBOutlet weak var m_btnShortCut: NSButton!
    @IBOutlet weak var m_indicator: NSProgressIndicator!
    @IBOutlet weak var m_lyContentWidth: NSLayoutConstraint!
    @IBOutlet weak var m_lyContentHeight: NSLayoutConstraint!
    private let m_wvMain:WebView = {
        let wv = WebView()
        wv.shouldUpdateWhileOffscreen = true
        wv.translatesAutoresizingMaskIntoConstraints = false
        return wv
    }()
    private let kakaoURL:URL = URL(string: "https://m.translate.kakao.com/")!
    private let papagoURL:URL = URL(string: "https://papago.naver.com/")!
    private let googleURL:URL = URL(string: "https://translate.google.co.kr/")!
    private let m_side_menu: NSMenu = {
        let root_menu = NSMenu()

        root_menu.addItem(NSMenuItem(title: "관하여", action: #selector(onAbout), keyEquivalent: ""))
        root_menu.addItem(NSMenuItem(title: "Preperences..", action: #selector(onPreperences), keyEquivalent: ","))
        root_menu.addItem(NSMenuItem.separator())
        let chg_trans = NSMenuItem(title: "번역기 바꾸기", action: nil, keyEquivalent: "")
        let chg_menu = NSMenu()
        let arr_trans:[NSMenuItem] = [
            NSMenuItem(title: "구글", action: #selector(onChangeTranslate(_:)), keyEquivalent: "1"),
            NSMenuItem(title: "파파고", action: #selector(onChangeTranslate(_:)), keyEquivalent: "2"),
            NSMenuItem(title: "카카오", action: #selector(onChangeTranslate(_:)), keyEquivalent: "3")
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
    
    @objc func onChangeTranslate(_ sender: NSMenuItem) {
        UserDefaults.standard.setValue(sender.tag, forKey: UserDefaults_DEFINE_KEY.domainKey.rawValue)
        self.loadWebTranslate(idx: sender.tag)
    }
    
    @objc func onClickHome(_ sender: NSButton) {
        let idx = UserDefaults.standard.integer(forKey: UserDefaults_DEFINE_KEY.domainKey.rawValue)
        self.loadWebTranslate(idx: idx)
    }
    
    private func loadWebTranslate(idx:Int) {
        var url:URL?
        
        guard let menu_trans = m_side_menu.item(at: 3)?.submenu else {
            return
        }
        for trans in menu_trans.items {
            trans.state = trans.tag == idx ? .on : .off
        }
        switch idx {
        case 0:
            url = googleURL
        case 1:
            url = papagoURL
        case 2:
            url = kakaoURL
        default: break
        }
        
        guard let v_url = url else { return }
        let request = URLRequest(url: v_url)
        m_wvMain.mainFrame.load(request)
    }
    
    @objc func onAbout() {
        guard let vc = NSStoryboard.init(name: "Settings", bundle: nil).instantiateController(withIdentifier: "Settings_About") as? Settings_About else {
            return
        }
        let windowVC = CTWindowController(window: NSWindow(contentViewController: vc))
        windowVC.showPopupView(self)
    }
    
    @objc func onPreperences() {
        guard let vc = NSStoryboard.init(name: "Settings", bundle: nil).instantiateController(withIdentifier: "Settings_Preferences") as? Settings_Preferences else {
            return
        }
        let windowVC = CTWindowController(window: NSWindow(contentViewController: vc))
        windowVC.showPopupView(self)
    }
    
    @objc func onExit() {
        NSApp.terminate(nil)
    }
    
    @IBAction func onClickSideMenu(_ sender: NSButton) {
        let p = NSPoint(x: 0, y: (sender.frame.height*2)-10)
        self.m_side_menu.popUp(positioning: self.m_side_menu.item(at: 0), at: p, in: sender)
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
    public func webView(_ sender: WebView!, didFinishLoadFor frame: WebFrame!) {
        self.loadingBar(show: false)
    }
    
    func webView(_ sender: WebView!, didStartProvisionalLoadFor frame: WebFrame!) {
        self.loadingBar(show: true)
    }
}
