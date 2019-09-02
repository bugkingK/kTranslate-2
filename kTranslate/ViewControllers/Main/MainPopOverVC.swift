//
//  MainPopOverVC.swift
//  AirPodsManager
//
//  Created by moon on 05/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa
import WebKit
import RxSwift

class MainPopOverVC: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindLayout()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        let width = UserDefaults.standard.integer(forKey: DEFINE_KEY.widthKey.rawValue)
        let height = UserDefaults.standard.integer(forKey: DEFINE_KEY.heightKey.rawValue)
        m_lyContentWidth.constant = CGFloat(width)
        m_lyContentHeight.constant = CGFloat(height)
        
        m_btnShortCut.title = UserDefaults.standard.string(forKey: DEFINE_KEY.shortCutStringKey.rawValue) ?? ""
    }
    
    @IBOutlet fileprivate weak var m_lyContentWidth: NSLayoutConstraint!
    @IBOutlet fileprivate weak var m_lyContentHeight: NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var m_vwWebView: NSView!
    @IBOutlet fileprivate weak var m_btnShortCut: NSButton!
    @IBOutlet fileprivate weak var m_indicator: NSProgressIndicator!
    @IBOutlet fileprivate weak var m_st_btns: NSStackView!
    @IBOutlet fileprivate weak var m_btnA: CTCircleButton!
    @IBOutlet fileprivate weak var m_btnI: CTCircleButton!
//    @IBOutlet fileprivate weak var m_btnM: CTCircleButton!
    
    fileprivate var m_side_menu: NSMenu = NSMenu()
    fileprivate var m_arrBtnCircle:[CTCircleButton] = []
    fileprivate let m_dispose_bag:DisposeBag = DisposeBag()
    fileprivate let m_wvMain:WebView = {
        let wv = WebView()
        wv.shouldUpdateWhileOffscreen = true
        wv.translatesAutoresizingMaskIntoConstraints = false
        wv.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 12_1_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecok) Version/12.0 Mobile/15E148 Safari/604.1"
        return wv
    }()
    
    fileprivate func setupLayout() {
        NSApp.activate(ignoringOtherApps: true)
        
        m_wvMain.frameLoadDelegate = self
        m_vwWebView.addSubview(m_wvMain)
        NSLayoutConstraint.activate([
            m_wvMain.topAnchor.constraint(equalTo: m_vwWebView.topAnchor),
            m_wvMain.leadingAnchor.constraint(equalTo: m_vwWebView.leadingAnchor),
            m_wvMain.trailingAnchor.constraint(equalTo: m_vwWebView.trailingAnchor),
            m_wvMain.bottomAnchor.constraint(equalTo: m_vwWebView.bottomAnchor)
        ])
        
        let bAlways = UserDefaults.standard.bool(forKey: DEFINE_KEY.alwaysShowKey.rawValue)
        self.m_btnA.state = bAlways ? .on : .off
        self.m_btnA.actionKey = AnalyticsAction.alwaysShow
        
        m_side_menu.addItems([
            NSMenuItem.make(title: "About kTranslate", target: self, action: #selector(onAbout), keyEquivalent: ""),
            NSMenuItem.make(title: "Preperences..", target: self, action: #selector(onPreperences), keyEquivalent: ""),
            NSMenuItem.separator(),
            NSMenuItem.make(title: "Quit", target: NSApp, action: #selector(NSApp.terminate(_:)), keyEquivalent: "q")
        ])
        
        self.m_arrBtnCircle = m_st_btns.subviews as! [CTCircleButton]
        let idx = UserDefaults.standard.integer(forKey: DEFINE_KEY.domainKey.rawValue)
        self.loadWebTranslate(idx: idx)
    }
    
    fileprivate func bindLayout() {
        m_btnA.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                let state = self.m_btnA.state == .on
                UserDefaults.standard.set(state, forKey: DEFINE_KEY.alwaysShowKey.rawValue)
            })
            .disposed(by: m_dispose_bag)
        
        m_btnI.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                guard let sender = self.m_btnI else { return }
                let p = NSPoint(x: 0, y: (sender.frame.height*2)-10)
                self.m_side_menu.popUp(positioning: self.m_side_menu.item(at: 0), at: p, in: sender)
            })
            .disposed(by: m_dispose_bag)
        
//        m_btnM.rx.tap
//            .subscribe(onNext: { [unowned self] _ in
//                guard let sender = self.m_btnI else { return }
//                PopoverController.sharedInstance().toggleMemoMenu(isShow: sender.state == .on)
//            })
//            .disposed(by: m_dispose_bag)
        
        m_btnShortCut.rx.tap
            .bind(onNext: onPreperences)
            .disposed(by: m_dispose_bag)
        
        for btn in self.m_arrBtnCircle {
            btn.rx.tap
                .subscribe(onNext: { [unowned self] _ in
                    self.onChangeTranslate(btn)
                })
                .disposed(by: m_dispose_bag)
        }
    }
    
    @objc public func onChangeTranslate(_ sender: AnyObject) {
        self.loadWebTranslate(idx: sender.tag)
    }
    
    @objc private func onAbout() {
        NSStoryboard.showStoryboard(sbName: "Settings", vcName: "Settings_About")
    }
    
    @objc public func onPreperences() {
        NSStoryboard.showStoryboard(sbName: "Settings", vcName: "Settings_Preferences")
    }
    
    private func loadWebTranslate(idx:Int) {
        var url:URL?
        guard let m_arr_site = UserDefaults.standard.array(forKey: DEFINE_KEY.siteAddressKey.rawValue) as? [String] else {
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
        
        UserDefaults.standard.set(idx, forKey: DEFINE_KEY.domainKey.rawValue)
        let request = URLRequest(url: v_url)
        m_wvMain.mainFrame.load(request)
        
//        MPGoogleAnalyticsTracker.trackEvent(ofCategory: AnalyticsCategory.root, action:AnalyticsAction.moveSite, label: v_url.path, value: 0)
    }
}

extension MainPopOverVC: WebFrameLoadDelegate {
    private func loadingBar(show:Bool) {
        if show {
            self.m_indicator.isHidden = false
            self.m_indicator.startAnimation(self)
        } else {
            self.m_indicator.isHidden = true
            self.m_indicator.stopAnimation(self)
        }
    }
    
    func webView(_ sender: WebView!, didFinishLoadFor frame: WebFrame!) {
        self.loadingBar(show: false)
    }
    
    func webView(_ sender: WebView!, didStartProvisionalLoadFor frame: WebFrame!) {
        self.loadingBar(show: true)
    }
}
