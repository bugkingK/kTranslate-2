//
//  Main_Chatting.swift
//  Translate-Text
//
//  Created by moon on 03/09/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

struct ChattingData {
    enum TYPE { case You, Me }
    
    var strProfile:String?
    var strName:String?
    var strMessage:String
    var type:TYPE
    
    init(profile:String?, name:String?, message:String, type:TYPE) {
        self.strProfile = profile
        self.strName = name
        self.strMessage = message
        self.type = type
    }
    
    init(message:String, type:TYPE) {
        self.strMessage = message
        self.type = type
    }
}

class Main_Chatting: NSViewController, NSTextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        setupLayout()
        bindLayout()
    }
    
    @IBOutlet weak var m_tv_main: NSTableView!
    @IBOutlet weak var m_ttv_input: NSTextView!
    @IBOutlet weak var m_btn_send: NSButton!
    @IBOutlet weak var m_btn_source: CustomButton!
    @IBOutlet weak var m_btn_target: CustomButton!
    @IBOutlet weak var m_box_present: NSBox!
    
    fileprivate var m_translator:Translator = Translator()
    fileprivate var m_dispose_bag:DisposeBag = DisposeBag()
    
    fileprivate var m_sel_source:String?
    fileprivate var m_sel_target:String = "en"
    fileprivate var m_source_presenter:Presenter!
    fileprivate var m_target_presenter:Presenter!
    fileprivate var m_arr_datas:[ChattingData] = [] {
        didSet {
            m_tv_main.reloadData()
            let numberOfRows = m_tv_main.numberOfRows
            if numberOfRows > 0 {
                m_tv_main.scrollRowToVisible(numberOfRows-1)
            }
        }
    }
    
    fileprivate func setupLayout() {
        m_tv_main.delegate = self
        m_tv_main.dataSource = self
        m_ttv_input.delegate = self
        m_ttv_input.insertionPointColor = .black
        m_ttv_input.font = NSFont.systemFont(ofSize: 13)
        let isKorean = NSLocale.preferredLanguages[0] == "ko-KR"
        let target = isKorean ? "ko" : "en"
        let message = isKorean ? "번역하는 내용을 입력해주세요." : "Please enter your translation."
        m_arr_datas = [
            ChattingData(message: message, type: .Me),
        ]
        setSupportLanguage(target: target)
    }
    
    fileprivate func bindLayout() {
        m_btn_send.rx.tap
            .bind(onNext: onClickBtnSend)
            .disposed(by: m_dispose_bag)
        
        m_translator.meText
            .subscribe(onNext: { (text) in
                let data = ChattingData(message: text, type: .Me)
                self.m_arr_datas.append(data)
            }).disposed(by: m_dispose_bag)
        
        Observable.of(m_translator.google.translatedText,
                      m_translator.papago.translatedText,
                      m_translator.kakao.translatedText,
                      m_translator.kTranslate.translatedText)
            .merge()
            .subscribe(onNext: { (text, type) in
                let data = ChattingData(profile: "icon-\(type.rawValue)", name: type.rawValue, message: text, type: .You)
                self.m_arr_datas.append(data)
            })
            .disposed(by: m_dispose_bag)
        
        m_btn_source.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.m_target_presenter.popup_dismiss()
                self.m_source_presenter.toggle()
            })
            .disposed(by: m_dispose_bag)
        m_btn_target.rx.tap
            .subscribe(onNext: { _ in
                self.m_source_presenter.popup_dismiss()
                self.m_target_presenter.toggle()
            })
            .disposed(by: m_dispose_bag)
        
        m_ttv_input.rx.string
            .scan("") { (previous, new) -> String in
                if new.count > 1000 {
                    self.toast(message: "You can enter up to 1000 characters.")
                    return previous
                } else {
                    return new
                }
            }
            .subscribe(m_ttv_input.rx.string)
            .disposed(by: m_dispose_bag)
    }
    
    fileprivate func onClickBtnSend() {
        let text = self.m_ttv_input.string
        if text != "" {
            let data = ChattingData(message: text, type: .Me)
            self.m_arr_datas.append(data)
            self.m_ttv_input.string = ""
            self.m_translator.run(text: text, source: m_sel_source, target: m_sel_target)
        }
        Analyst.shared.track(event: .translate)
    }
    
    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(insertNewline(_:)) {
            onClickBtnSend()
            return true
        }
        
        return false
    }
    
    public func setSupportLanguage(target:String) {
        let isKorean = NSLocale.preferredLanguages[0] == "ko-KR"
        let sourceName = isKorean ? "언어감지" : "Detect"
        self.m_btn_source.title = sourceName
        let targetName = isKorean ? "영어" : "English"
        self.m_btn_target.title = targetName
        
        let sourceVC = NSStoryboard.make(sbName: "Main", vcName: "Main_ChooseLanguage") as! Main_ChooseLanguage
        sourceVC.setup(select:nil, isSource: true, selBlock: { [unowned self] sel in
            self.m_btn_source.title = sel.0
            self.m_sel_source = sel.1
            self.m_source_presenter.popup_dismiss()
        })
        
        let targetVC = NSStoryboard.make(sbName: "Main", vcName: "Main_ChooseLanguage") as! Main_ChooseLanguage
        targetVC.setup(select:"en", isSource: false, selBlock: { [unowned self] sel in
            self.m_btn_target.title = sel.0
            self.m_sel_target = sel.1!
            self.m_target_presenter.popup_dismiss()
        })
        
        m_source_presenter = Presenter.instance()
            .setTarget(self, m_box_present)
            .setHeight(250)
            .setContent(sourceVC)
        
        m_target_presenter = Presenter.instance()
            .setTarget(self, m_box_present)
            .setHeight(250)
            .setContent(targetVC)
    }
    
}

extension Main_Chatting: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return m_arr_datas.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let item = m_arr_datas[row]
        let identifier = item.type == .Me ? "ChattingSendCell" : "ChattingReciveCell"
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init(identifier), owner: nil) as? ChattingCell else {
            return nil
        }
        
        if let profileName = item.strProfile, let name = item.strName {
            cell.imgProfile?.image = NSImage(named: profileName)
            cell.lbName?.stringValue = name
        }
        
        cell.lbMessage.stringValue = item.strMessage
        return cell
    }
}

class ChattingCell:NSTableCellView {
    @IBOutlet weak var imgProfile:NSImageView?
    @IBOutlet weak var lbName:NSTextField?
    @IBOutlet weak var lbMessage:NSTextField!
    @IBOutlet weak var boxType: NSBox!
    @IBOutlet weak var btnCopy: NSButton?
    
    fileprivate var m_dispose_bag:DisposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnCopy?.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                let pasteBoard = NSPasteboard.general
                pasteBoard.declareTypes([], owner: nil)
                pasteBoard.setString(self.lbMessage.stringValue, forType: .string)
                self.findViewController()?.toast(message: "It's been copied.")
            }).disposed(by: m_dispose_bag)
    }
}

