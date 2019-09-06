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
            loadData()
            self.m_cv_main.reloadData()
        }
        let indexPath = IndexPath(item: self.m_n_select, section: 0)
        self.m_cv_main.scrollToItems(at: [indexPath], scrollPosition: .centeredVertically)
    }
    
    @IBOutlet weak var m_cv_main: NSCollectionView!
    fileprivate var m_arr_datas:GoogleTranslation.SupportData?
    fileprivate var m_sel_block:((_ sel:(String, String?))->())? = nil
    
    fileprivate var m_str_select:String? = nil
    fileprivate var m_n_select:Int = 0
    fileprivate var m_b_source:Bool = false
    
    fileprivate func setupLayout() {
        m_cv_main.delegate = self
        m_cv_main.dataSource = self
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = NSSize(width: self.view.frame.width/4, height: 40)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        m_cv_main.collectionViewLayout = flowLayout
        self.m_cv_main.reloadData()
    }
    
    public func setup(select:String?, isSource:Bool, selBlock:((_ sel:(String, String?))->())? = nil) {
        m_sel_block = selBlock
        m_b_source = isSource
        m_str_select = select
        loadData()
    }
    
    public func loadData() {
        let isKorean = NSLocale.preferredLanguages[0] == "ko-KR"
        let target = isKorean ? "ko" : "en"
        GoogleTranslation.supportLanguages(target: target) { [unowned self] (datas) in
            var v_datas = datas
            if self.m_b_source {
                let isKorean = NSLocale.preferredLanguages[0] == "ko-KR"
                let sourceName = isKorean ? "언어감지" : "Detect"
                v_datas.languages.insert((name: sourceName, key: nil), at: 0)
            }
            
            self.m_arr_datas = v_datas
            for (idx, data) in v_datas.languages.enumerated() {
                if data.key == self.m_str_select {
                    self.m_n_select = idx
                }
            }
        }
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