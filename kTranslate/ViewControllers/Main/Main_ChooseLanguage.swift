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

        cell.btnTitle.title = language.name
        cell.btnTitle.target = self
        cell.btnTitle.tag = indexPath.item
        cell.btnTitle.action = #selector(onClickBtnTitle(_:))
        if indexPath.item == m_n_select {
            cell.btnTitle.backgroundColor = NSColor.init(red: 250/255, green: 229/255, blue: 77/255, alpha: 1)
        } else {
            cell.btnTitle.backgroundColor = NSColor.white
        }
        return cell
    }
}

class ChooseLanguageCell: NSCollectionViewItem {
    @IBOutlet weak var btnTitle: CustomButton!
}
