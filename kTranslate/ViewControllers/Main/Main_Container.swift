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
    
    @IBOutlet weak var m_btn_always: CTCircleButton!
    @IBOutlet weak var m_btn_info: CTCircleButton!
    @IBOutlet weak var m_btn_translator: NSButton!
    @IBOutlet weak var m_btn_command: NSButton!
    
    fileprivate var m_dispose_bag:DisposeBag = DisposeBag()
    fileprivate var m_vc_chatting:ChattingVC!
    
    fileprivate func setupLayout() {
        m_vc_chatting = NSStoryboard.make(sbName: "Main", vcName: "ChattingVC") as? ChattingVC
        self.bindToViewController(targetVC: m_vc_chatting)
    }
    
    fileprivate func bindLayout() {
        m_btn_always.rx.tap
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: m_dispose_bag)
        
        m_btn_info.rx.tap
            .subscribe(onNext: { _ in
                
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
    
}
