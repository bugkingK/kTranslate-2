//
//  Main_ChooseLanguage.swift
//  Translate-Text
//
//  Created by moon on 04/09/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import Cocoa

class Main_ChooseLanguage: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if m_arr_datas == nil {
            guard let parent = self.parent as? Main_Chatting else { return }
            let isKorean = NSLocale.preferredLanguages[0] == "ko-KR"
            let target = isKorean ? "ko" : "en"
            parent.setSupportLanguage(target: target)
        }
    }
    
    @IBOutlet weak var m_cv_main: NSCollectionView!
    fileprivate var m_arr_datas:GoogleTranslation.SupportData?
    fileprivate var m_n_select:Int = 0
    fileprivate var m_sel_block:((_ sel:(String, String?))->())? = nil
    
    fileprivate func setupLayout() {
        m_cv_main.delegate = self
        m_cv_main.dataSource = self
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: self.view.frame.width/4, height: 40)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        m_cv_main.collectionViewLayout = flowLayout
    }
    
    public func setup(datas:GoogleTranslation.SupportData, select:String?, selBlock:((_ sel:(String, String?))->())? = nil) {
        m_arr_datas = datas
        for (idx, data) in datas.languages.enumerated() {
            if data.key == select {
                m_n_select = idx
            }
        }
        
        m_sel_block = selBlock
    }
    
    @objc fileprivate func onClickBtnTitle(_ sender:NSButton) {
        let item = sender.tag
        m_n_select = item
        guard let ret_val = m_arr_datas?.languages[item] else { return }
        m_sel_block?(ret_val)
    }
    
}

extension Main_ChooseLanguage: NSCollectionViewDataSource, NSCollectionViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return m_arr_datas?.languages.count ?? 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChooseLanguageCell"), for: indexPath) as? ChooseLanguageCell,
              let language = m_arr_datas?.languages[indexPath.item] else {
            return NSCollectionViewItem.init()
        }

        let item = indexPath.item
        cell.btnTitle.title = language.name
        cell.btnTitle.target = self
        cell.btnTitle.tag = item
        cell.btnTitle.action = #selector(onClickBtnTitle(_:))
        cell.btnTitle.backgroundColor = item == m_n_select ? .hex_EE768A : .white
        cell.btnTitle.textColor = item == m_n_select ? .white : .hex_222428
        return cell
    }
}

class ChooseLanguageCell: NSCollectionViewItem {
    @IBOutlet weak var btnTitle: CustomButton!
}
