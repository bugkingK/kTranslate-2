//
//  Main_Container.swift
//  kTranslate
//
//  Created by moon on 05/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class Main_Container: CTContainerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setupLayout()
        bindLayout()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        let width = UserDefault.cgfloat(forKey: .sWidth)
        let height = UserDefault.cgfloat(forKey: .sHeight)
        resizeContainer(width: width, height: height)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        m_btn_command.title = UserDefault.string(forKey: .sShortCutKey) ?? "set any shortcut"
    }
    
    @IBOutlet weak var m_btn_always: CTCircleButton!
    @IBOutlet weak var m_btn_info: CTCircleButton!
    @IBOutlet weak var m_btn_translator: NSButton!
    @IBOutlet weak var m_btn_command: NSButton!
    
    fileprivate var m_dispose_bag:DisposeBag = DisposeBag()
    public var m_vc_chatting:Main_Chatting!
    fileprivate var m_side_menu:NSMenu = NSMenu()
    
    fileprivate func setupLayout() {
        m_side_menu.addItems([
            NSMenuItem.make("About kTranslate", self, #selector(onClickMenuAbout), ""),
            NSMenuItem.make("Preperences..", self, #selector(onClickMenuPreference), ""),
            NSMenuItem.separator(),
            NSMenuItem.make("History", self, #selector(onClickMenuHistory), ""),
            NSMenuItem.separator(),
            NSMenuItem.make("Quit", NSApp, #selector(NSApp.terminate(_:)), "")
        ])
        
        m_vc_chatting = NSStoryboard.make(sbName: "Main", vcName: "Main_Chatting") as? Main_Chatting
        bindToViewController(targetVC: m_vc_chatting)
    }
    
    fileprivate func bindLayout() {
        m_btn_always.state = UserDefault.bool(forKey: .bAlways) ? .on : .off
        m_btn_always.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                UserDefault.set(self.m_btn_always.state == .on, key: .bAlways)
            })
            .disposed(by: m_dispose_bag)
        
        m_btn_info.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                let sender = self.m_btn_info!
                let p = NSPoint(x: 0, y: (sender.frame.height*2)-10)
                self.m_side_menu.popUp(positioning: self.m_side_menu.item(at: 0), at: p, in: sender)
            })
            .disposed(by: m_dispose_bag)
        
        m_btn_translator.rx.tap
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: m_dispose_bag)
        
        m_btn_command.rx.tap
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: m_dispose_bag)
    }
    
    @objc fileprivate func onClickMenuAbout() {
        CTWindowController.showWindow(sbName: "Setting", vcName: "Setting_About")
    }
    
    @objc fileprivate func onClickMenuPreference() {
        CTWindowController.showWindow(sbName: "Setting", vcName: "Setting_Preference")
    }
    
    @objc fileprivate func onClickMenuHistory() {
        let vc = NSStoryboard.make(sbName: "Popup", vcName: "Popup_UseHistory") as! Popup_UseHistory
        self.presentAsSheet(vc)
    }
}
