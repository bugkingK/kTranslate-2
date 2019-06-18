//
//  SplitVC_Sticker.swift
//  kTranslate
//
//  Created by moon on 18/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa

class SplitVC_Sticker: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.setupLayout()
        self.refreshData()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        let width = UserDefaults.standard.integer(forKey: UserDefaults_DEFINE_KEY.menuWidthKey.rawValue)
        m_lyWidth.constant = CGFloat(width)
    }
    
    @IBOutlet var m_tvMain: NSTableView!
    @IBOutlet weak var m_lyWidth: NSLayoutConstraint!
    
    private var m_db_arr_stickers:[StickerData] = []
    private var m_arr_stickers:[String] = []
    private var m_idxPJ:Int = 0
    private var m_appDelegate:AppDelegate = {
        return NSApplication.shared.delegate as! AppDelegate
    }()
    private let m_right_menu: NSMenu = {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Edit", action: #selector(editSticker), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Delete...", action: #selector(deleteSticker), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "New Sticker", action: #selector(addNewSticker(_:)), keyEquivalent: ""))
        return menu
    }()
    
    private func setupLayout() {
        m_tvMain.delegate = self
        m_tvMain.dataSource = self
        m_tvMain.menu = m_right_menu
        m_tvMain.doubleAction = #selector(editSticker)
        m_tvMain.registerForDraggedTypes([.string, .tableViewIndex])
        m_tvMain.setDraggingSourceOperationMask([.copy, .delete], forLocal: false)
    }
    
    private func refreshData() {
        m_db_arr_stickers = DBSticker.getStickerList(idxPJ:m_idxPJ)
        var arr_sticker:[String] = []
        for stic in m_db_arr_stickers {
            arr_sticker.append(stic.sContent)
        }
        m_arr_stickers = arr_sticker
        m_tvMain.reloadData()
    }
    
    @objc private func editSticker() {
        guard m_tvMain.clickedRow >= 0 else { return }
        let row = m_tvMain.clickedRow
        guard let cell = m_tvMain.view(atColumn: 0, row: row, makeIfNecessary: false) as? SplitVCStickerContentCell else {
            return
        }
        cell.tf_content.isEditable = true
        cell.tf_content.isSelectable = true
        cell.tf_content.becomeFirstResponder()
    }
    
    @IBAction func addNewSticker(_ sender: Any) {
        if m_arr_stickers.last == "" { return }
        if !DBSticker.addSticker(idxPJ: m_idxPJ, content: "", orderSK:m_arr_stickers.count) {
            CommonUtil.alertMessage("Sticker를 생성하지 못했습니다.")
            return
        }
        m_db_arr_stickers = DBSticker.getStickerList(idxPJ:m_idxPJ)
        let indexSet = IndexSet(integer: m_tvMain.numberOfRows-1)
        m_arr_stickers.append("")
        m_tvMain.insertRows(at: indexSet, withAnimation: .slideUp)
        
        guard let cell = m_tvMain.view(atColumn: 0, row: m_tvMain.numberOfRows-2, makeIfNecessary: false) as? SplitVCStickerContentCell else {
            return
        }
        cell.tf_content.isEditable = true
        cell.tf_content.isSelectable = true
        cell.tf_content.becomeFirstResponder()
    }
    
    /// 스티커를 수정하고 엔터를 치면 DB에 저장합니다.
    @objc private func updateStickerFromTextField(_ sender: NSTextField) {
        let content = sender.stringValue
        if content == "" { return }
        let row = m_tvMain.row(for: sender)
        
        m_db_arr_stickers[row].sContent = content
        if !DBSticker.updateSticker(data: m_db_arr_stickers[row]) {
            CommonUtil.alertMessage("Sticker를 변경하지 못했습니다.")
            return
        }
        m_arr_stickers[row] = content
        self.refreshData()
        sender.isEditable = false
        sender.isSelectable = false
        
        print("row : \(row), result:\(content)")
    }
    
    @objc private func deleteSticker() {
        guard m_tvMain.clickedRow >= 0 else { return }
        let row = m_tvMain.clickedRow
        let delete_idx = m_db_arr_stickers[row].idx
        
        if !DBSticker.deleteSticker(idx: delete_idx) {
            CommonUtil.alertMessage("Sticker를 삭제하지 못했습니다.")
            return
        }
        m_tvMain.removeRows(at: IndexSet(integer: row), withAnimation: .slideUp)
        print("row : \(row) 지웁니다")
    }
    
}

extension SplitVC_Sticker {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return m_arr_stickers.count+1
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if m_arr_stickers.count == row {
            guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SplitVCStickerAddCell"), owner: nil) as? SplitVCStickerAddCell else {
                return nil
            }
            return cell
        }
        
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SplitVCStickerContentCell"), owner: self) as? SplitVCStickerContentCell else {
            return nil
        }
        
        cell.setupLayout()
        cell.tf_content.stringValue = m_arr_stickers[row]
        cell.tf_content.target = self
        cell.tf_content.action = #selector(updateStickerFromTextField(_:))
        if cell.tf_content.stringValue != "" {
            cell.tf_content.isEditable = false
            cell.tf_content.isSelectable = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        let chkRow:Int = row-1 == -1 ? 0 : row-1
        if m_tvMain.view(atColumn: 0, row:chkRow , makeIfNecessary: false)?.className == SplitVCStickerAddCell.className() {
            return []
        }
        guard dropOperation == .above else { return [] }
        
        // If dragging to reorder, use the gap feedback style. Otherwise, draw insertion marker.
        if let source = info.draggingSource as? NSTableView, source === tableView {
            tableView.draggingDestinationFeedbackStyle = .gap
        } else {
            tableView.draggingDestinationFeedbackStyle = .regular
        }
        return .move
    }
    
    
    func tableView(_ tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        if m_arr_stickers.count == row { return nil }
        return StickersWriter(sticker: m_arr_stickers[row], at: row)
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        guard let items = info.draggingPasteboard.pasteboardItems else { return false }
        
        let oldIndexes = items.compactMap{ $0.integer(forType: .tableViewIndex) }
        if !oldIndexes.isEmpty {
            m_arr_stickers.move(with: IndexSet(oldIndexes), to: row)
            m_db_arr_stickers.move(with: IndexSet(oldIndexes), to: row)
            // The ol' Stack Overflow copy-paste. Reordering rows can get pretty hairy if
            // you allow multiple selection. https://stackoverflow.com/a/26855499/7471873
            
            tableView.beginUpdates()
            var oldIndexOffset = 0
            var newIndexOffset = 0
            
            for oldIndex in oldIndexes {
                if oldIndex < row {
                    tableView.moveRow(at: oldIndex + oldIndexOffset, to: row - 1)
                    oldIndexOffset -= 1
                } else {
                    tableView.moveRow(at: oldIndex, to: row + newIndexOffset)
                    newIndexOffset += 1
                }
            }
            tableView.endUpdates()
            
            for i in 0..<m_db_arr_stickers.count {
                m_db_arr_stickers[i].nOrderSK = i
            }
            //            for (i, stic) in m_db_arr_stickers.enumerated() {
            //                stic.nOrderSK = i
            //            }
            if !DBSticker.updateArraySticker(datas: m_db_arr_stickers) {
                CommonUtil.alertMessage("Sticker를 이동하지 못했습니다.")
            }
            return true
        }
        
        let newFruits = items.compactMap{ $0.string(forType: .string) }
        m_arr_stickers.insert(contentsOf: newFruits, at: row)
        tableView.insertRows(at: IndexSet(row...row + newFruits.count - 1),
                             withAnimation: .slideDown)
        return true
    }
    
    
    func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        // Handle items dragged to Trash
        if operation == .delete, let items = session.draggingPasteboard.pasteboardItems {
            let indexes = items.compactMap{ $0.integer(forType: .tableViewIndex) }
            
            for index in indexes.reversed() {
                m_arr_stickers.remove(at: index)
            }
            tableView.removeRows(at: IndexSet(indexes), withAnimation: .slideUp)
        }
    }
}

class SplitVCStickerContentCell:NSTableCellView {
    @IBOutlet var box_content:NSBox!
    @IBOutlet var tf_content:DynamicTextField!
    @IBOutlet var btn_delete:NSButton!
    
    func setupLayout() {
        let color = NSColor.init(calibratedRed: 140, green: 140, blue: 140, alpha: 0.5)
        let font = NSFont.systemFont(ofSize: 13)
        let attrs = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font]
        let placeHolderStr = NSAttributedString(string: "More Sticker to do..", attributes: attrs)
        tf_content.placeholderAttributedString = placeHolderStr
    }
}

class SplitVCStickerAddCell:NSTableCellView {
    @IBOutlet var btn_add: NSButton!
}



class StickersWriter: NSObject, NSPasteboardWriting {
    var sticker: String
    var index: Int
    
    init(sticker: String, at index: Int) {
        self.sticker = sticker
        self.index = index
    }
    
    func writableTypes(for pasteboard: NSPasteboard) -> [NSPasteboard.PasteboardType] {
        return [.string, .tableViewIndex]
    }
    
    func pasteboardPropertyList(forType type: NSPasteboard.PasteboardType) -> Any? {
        switch type {
        case .string:
            return sticker
        case .tableViewIndex:
            return index
        default:
            return nil
        }
    }
}



extension NSPasteboard.PasteboardType {
    static let tableViewIndex = NSPasteboard.PasteboardType("io.natethompson.tableViewIndex")
}



extension NSPasteboardItem {
    open func integer(forType type: NSPasteboard.PasteboardType) -> Int? {
        guard let data = data(forType: type) else { return nil }
        let plist = try? PropertyListSerialization.propertyList(
            from: data,
            options: .mutableContainers,
            format: nil)
        return plist as? Int
    }
}

extension Array {
    // These functions from sooop on GitHub
    // https://gist.github.com/sooop/3c964900d429516ba48bd75050d0de0a
    mutating func move(from start: Index, to end: Index) {
        guard (0..<count) ~= start, (0...count) ~= end else { return }
        if start == end { return }
        let targetIndex = start < end ? end - 1 : end
        insert(remove(at: start), at: targetIndex)
    }
    
    mutating func move(with indexes: IndexSet, to toIndex: Index) {
        let movingData = indexes.map{ self[$0] }
        let targetIndex = toIndex - indexes.filter{ $0 < toIndex }.count
        for (i, e) in indexes.enumerated() {
            remove(at: e - i)
        }
        insert(contentsOf: movingData, at: targetIndex)
    }
}
