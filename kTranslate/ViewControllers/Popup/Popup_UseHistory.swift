//
//  Popup_UseHistory.swift
//  kTranslate
//
//  Created by moon on 09/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa
import RxSwift

class Popup_UseHistory: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setupLayout()
        bindLayout()
    }
    
    @IBOutlet weak var m_tv_main: NSTableView!
    @IBOutlet weak var m_btn_close: NSButton!
    
    fileprivate var m_arr_datas:[UseHistoryData] = []
    fileprivate let m_disposed_bag:DisposeBag = DisposeBag()
    
    fileprivate func setupLayout() {
        m_tv_main.delegate = self
        m_tv_main.dataSource = self
        m_arr_datas = DBUseHistory.get(limit: 50)
        m_tv_main.reloadData()
    }
    
    fileprivate func bindLayout() {
        m_btn_close.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.dismiss(self)
            })
            .disposed(by: m_disposed_bag)
    }
}

extension Popup_UseHistory: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return m_arr_datas.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = m_arr_datas[row]
        let identifier = "ChattingSendCell"
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init(identifier), owner: nil) as? ChattingCell else {
            return nil
        }
        
        cell.lbMessage.stringValue = item.sContent
        cell.lbNumberOfChar.stringValue = "\(item.sCreatedDate)"
        return cell
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        guard let containerVC = self.presentingViewController as? Main_Container else { return true }
        let item = m_arr_datas[row]
        containerVC.m_vc_chatting.m_ttv_input.string = item.sContent
        containerVC.m_vc_chatting.m_btn_send.performClick(self)
        self.dismiss(self)
        return true
    }
    
    
}
