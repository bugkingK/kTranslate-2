//
//  Settings_Left.swift
//  LogiAppManager-v2
//
//  Created by moon on 09/06/2019.
//  Copyright © 2019 banaple. All rights reserved.
//

import Cocoa

class Settings_Left: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        m_tvMain.dataSource = self
        m_tvMain.delegate = self
        
        
        guard let splitVC = self.parent as? NSSplitViewController else {
            return
        }
        
        guard let tabVC = splitVC.children.last as? NSTabViewController else {
            return
        }
        
        m_tbMain = tabVC
        m_tbMain.preferredContentSize = NSSize(width: 500, height: 300)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        self.m_tvMain.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
        if !self.tableView(m_tvMain, shouldSelectRow: 1) {
            return
        }
        if !self.tableView(m_tvMain, shouldSelectRow: 0) {
            return
        }
    }
    
    @IBOutlet weak var m_tvMain: NSTableView!
    private weak var m_tbMain: NSTabViewController!
    private var m_arrMenu:[String] = ["Welcome", "Preferences", "About"]
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return m_arrMenu.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SettingsLeftCell"), owner: nil) as? NSTableCellView else {
            return nil
        }
        
        cell.textField?.stringValue = m_arrMenu[row]
        return cell
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        m_tbMain.selectedTabViewItemIndex = row
        return true
    }
    
    func tableView(_ tableView: NSTableView, typeSelectStringFor tableColumn: NSTableColumn?, row: Int) -> String? {
        return nil
    }
    
}
