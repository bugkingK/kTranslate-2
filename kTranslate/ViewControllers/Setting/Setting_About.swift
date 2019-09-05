//
//  Setting_About.swift
//  kTranslate
//
//  Created by bugking on 05/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class Setting_About: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setupLayout()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.delegate = self
    }
    
    @IBOutlet weak var m_lb_version: NSTextField!
    @IBOutlet weak var m_st_abouts: NSStackView!
    fileprivate var m_arr_about:[CTCircleButton] = []
    fileprivate let m_dispose_bag:DisposeBag = DisposeBag()
    
    fileprivate func setupLayout() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        m_lb_version.stringValue = version
        m_arr_about = m_st_abouts.subviews as! [CTCircleButton]
        
        for about in m_arr_about {
            about.rx.tap
                .subscribe(onNext: { _ in
                    var url:URL?
                    
                    switch about.tag {
                    case 0: url = URL(string: "mailto:myway0710@naver.com")
                    case 1: url = URL(string: "https://github.com/bugkingK")
                    case 2: url = URL(string: "https://bugkingk.github.io")
                    default: break
                    }
                    
                    guard let v_url = url else { return }
                    NSWorkspace.shared.open(v_url)
                })
                .disposed(by: m_dispose_bag)
        }
    }
    
}

extension Setting_About: NSWindowDelegate {
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        PopoverController.shared.showPopover(sender: self)
        return true
    }
}
