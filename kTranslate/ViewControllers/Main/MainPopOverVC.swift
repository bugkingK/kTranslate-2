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
        
//        m_vwWebView.addSubview(m_wvMain)
//        m_wvMain.topAnchor.constraint(equalTo: m_vwWebView.topAnchor).isActive = true
//        m_wvMain.leadingAnchor.constraint(equalTo: m_vwWebView.leadingAnchor).isActive = true
//        m_wvMain.trailingAnchor.constraint(equalTo: m_vwWebView.trailingAnchor).isActive = true
//        m_wvMain.bottomAnchor.constraint(equalTo: m_vwWebView.bottomAnchor).isActive = true
//        m_wvMain.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_1_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecok) Version/12.0 Mobile/15E148 Safari/604.1"
//        m_wvMain.editingDelegate = self
        
        self.m_btnA.target = self
        self.m_btnA.action = #selector(onClickAlwayShow(_:))
        let bAlways = UserDefaults.standard.bool(forKey: UserKey.alwaysShowKey.rawValue)
        self.m_btnA.state = bAlways ? .on : .off
        
        self.m_btnShortCut.target = self
        self.m_btnShortCut.action = #selector(onPreperences)
        self.m_arrBtnCircle = [m_btnCM1, m_btnCM2, m_btnCM3, m_btnCM4, m_btnCM5]
        for btn in self.m_arrBtnCircle {
            btn.target = self
            btn.action = #selector(onChangeTranslate(_:))
        }
        
        self.initMenu()
        
        let idx = UserDefaults.standard.integer(forKey: UserKey.domainKey.rawValue)
        self.loadWebTranslate(idx: idx)
        guard let initShortCutString = UserDefaults.standard.string(forKey: UserKey.shortCutStringKey.rawValue) else {
            self.onChangeShortcutButton(shortCut: "")
            return
        }
        self.onChangeShortcutButton(shortCut: initShortCutString)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
//        let width = UserDefaults.standard.integer(forKey: UserKey.widthKey.rawValue)
//        let height = UserDefaults.standard.integer(forKey: UserKey.heightKey.rawValue)
        
//        m_lyContentWidth.constant = CGFloat(width)
//        m_lyContentHeight.constant = CGFloat(height)
    }
    
    private func initMenu() {
        let root_menu = NSMenu()
        let arr_menu_items = [
            NSMenuItem(title: "About kTranslate", action: #selector(onAbout), keyEquivalent: ""),
            NSMenuItem(title: "Preperences..", action: #selector(onPreperences), keyEquivalent: ","),
            NSMenuItem.separator(),
            NSMenuItem(title: "Quit", action: #selector(onQuit), keyEquivalent: "q")
        ]
        
        for item in arr_menu_items {
            item.target = self
            root_menu.addItem(item)
        }
        
        m_side_menu = root_menu
    }
    
    @IBOutlet weak var m_vwWebView: NSView!
    @IBOutlet weak var m_btnShortCut: NSButton!
    @IBOutlet weak var m_lyContentWidth: NSLayoutConstraint!
    @IBOutlet weak var m_lyContentHeight: NSLayoutConstraint!
    @IBOutlet weak var m_btnCM1: CTCircleButton!
    @IBOutlet weak var m_btnCM2: CTCircleButton!
    @IBOutlet weak var m_btnCM3: CTCircleButton!
    @IBOutlet weak var m_btnCM4: CTCircleButton!
    @IBOutlet weak var m_btnCM5: CTCircleButton!
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
    }
    
    @objc private func onQuit() {
        NSApp.terminate(nil)
    }
    
    @objc private func onClickAlwayShow(_ sender:NSButton) {
        UserDefault.set(sender.state == .on, key: .bAlways)
    }
    
    @IBAction private func onClickSideMenu(_ sender: NSButton) {
        let p = NSPoint(x: 0, y: (sender.frame.height*2)-10)
        self.m_side_menu.popUp(positioning: self.m_side_menu.item(at: 0), at: p, in: sender)
    }
    
    private func loadWebTranslate(idx:Int) {
        var url:URL?
        guard let m_arr_site = UserDefaults.standard.array(forKey: UserKey.siteAddressKey.rawValue) as? [String] else {
            return
        }
        
        url = URL(string: m_arr_site[idx])
        
        guard let v_url = url else {
            m_arrBtnCircle[idx].state = .off
            self.onPreperences()
            return
        }
        
        for btn in m_arrBtnCircle {
            btn.state = btn.tag == idx ? .on : .off
        }
        
        UserDefaults.standard.set(idx, forKey: UserKey.domainKey.rawValue)
        let request = URLRequest(url: v_url)
        m_wvMain.mainFrame.load(request)
    }
    
    @IBAction func onClickBtnMenu(_ sender: NSButton) {
//        PopoverController.shared.toggleMemoMenu(isShow: sender.state == .on)
    }
}
