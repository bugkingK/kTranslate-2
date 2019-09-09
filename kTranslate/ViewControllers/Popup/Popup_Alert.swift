//
//  Popup_Alert.swift
//  kTranslate
//
//  Created by moon on 09/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa
import RxSwift

class Popup_Alert: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        bindLayout()
    }
    @IBOutlet weak var m_btn_no: CustomButton!
    @IBOutlet weak var m_btn_yes: CustomButton!
    fileprivate let m_dispose_bag:DisposeBag = DisposeBag()
    public var clipboardContent:String = ""
    public var presentVC:NSViewController?
    
    fileprivate func bindLayout() {
        m_btn_no.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.dismiss(self)
            })
            .disposed(by: m_dispose_bag)
        
        m_btn_yes.rx.tap
            .subscribe(onNext: { [unowned self] in
                guard let splitVC = self.presentVC as? NSSplitViewController else { return }
                guard let v_presentVC = splitVC.splitViewItems.first?.viewController as? Main_Container else { return }
                v_presentVC.m_vc_chatting.m_ttv_input.string = self.clipboardContent
                v_presentVC.m_vc_chatting.m_btn_send.performClick(self)
                self.dismiss(self)
            })
            .disposed(by: m_dispose_bag)
    }
    
}
