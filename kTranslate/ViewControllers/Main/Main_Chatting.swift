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
import AVFoundation

struct ChattingData {
    enum TYPE { case You, Me, Image }
    
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
    
    override func viewWillAppear() {
        super.viewWillAppear()
        m_translator.google.isActive = UserDefault.bool(forKey: .bTransGoogle)
        m_translator.papago.isActive = UserDefault.bool(forKey: .bTransPapago)
        m_translator.kakao.isActive = UserDefault.bool(forKey: .bTransKakao)
        m_translator.kTranslate.isActive = UserDefault.bool(forKey: .bTranskTranslate)
    }
    
    @IBOutlet weak var m_tv_main: NSTableView!
    @IBOutlet weak var m_ttv_input: NSTextView!
    @IBOutlet weak var m_btn_send: NSButton!
    @IBOutlet weak var m_btn_source: CustomButton!
    @IBOutlet weak var m_btn_target: CustomButton!
    @IBOutlet weak var m_box_present: NSBox!
    @IBOutlet weak var m_vw_drag_drop: ADragDropView!
    
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
        m_tv_main.registerForDraggedTypes([.URL])
        m_ttv_input.delegate = self
        m_ttv_input.insertionPointColor = .black
        m_ttv_input.font = NSFont.systemFont(ofSize: 13)
        m_vw_drag_drop.delegate = self
        m_vw_drag_drop.acceptedFileExtensions = ["png", "jpg", "jpeg"]
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
        DBUseHistory.add(content: text)
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
        var identifier = ""
        switch item.type {
        case .Me: identifier = "ChattingSendCell"
        case .You: identifier = "ChattingReciveCell"
        case .Image: identifier = "ChattingSendImageCell"
        }
        
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init(identifier), owner: nil) as? ChattingCell else {
            return nil
        }
        
        if let profileName = item.strProfile, let name = item.strName {
            cell.imgProfile?.image = NSImage(named: profileName)
            cell.lbName?.stringValue = name
        }
        
        if item.type != .Image {
            cell.lbMessage?.stringValue = item.strMessage
            cell.lbNumberOfChar?.stringValue = "\(item.strMessage.count)"
        } else {
            guard let v_url = URL(string: item.strMessage) else { return nil }
            cell.btnSendImage?.image = NSImage(contentsOf: v_url)
        }
        
        return cell
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        m_vw_drag_drop.isHidden = false
        return NSDragOperation.generic
    }
}

extension Main_Chatting: ADragDropViewDelegate {
    func dragDropView(_ draggingExited: ADragDropView) {
        m_vw_drag_drop.isHidden = true
    }
    func dragDropView(_ dragDropView: ADragDropView, droppedFileWithURL URL: URL) {
        m_vw_drag_drop.isHidden = true
        guard let v_img = NSImage(contentsOf: URL) else { return }
        let data = ChattingData(message: URL.absoluteString, type: .Image)
        self.m_arr_datas.append(data)
        m_translator.run(image: v_img, target: m_sel_target)
    }
}

class ChattingCell:NSTableCellView {
    @IBOutlet weak var imgProfile:NSImageView?
    @IBOutlet weak var lbName:NSTextField?
    @IBOutlet weak var lbMessage:NSTextField?
    @IBOutlet weak var boxType: NSBox!
    @IBOutlet weak var btnCopy: NSButton?
    @IBOutlet weak var btnSpeaker: NSButton?
    @IBOutlet weak var lbNumberOfChar: NSTextField?
    @IBOutlet weak var btnSendImage: NSButton?
    
    fileprivate var m_dispose_bag:DisposeBag = DisposeBag()
    fileprivate var m_synthesizer:NSSpeechSynthesizer = NSSpeechSynthesizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnCopy?.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                guard let message = self.lbMessage?.stringValue else { return }
                let pasteBoard = NSPasteboard.general
                pasteBoard.declareTypes([], owner: nil)
                pasteBoard.setString(message, forType: .string)
                self.findViewController()?.toast(message: "It's been copied.")
            })
            .disposed(by: m_dispose_bag)
        
        btnSpeaker?.rx.tap
            .subscribe(onNext: { [unowned self] in
                if self.m_synthesizer.isSpeaking {
                   self.m_synthesizer.stopSpeaking()
                } else {
                    guard let message = self.lbMessage?.stringValue else { return }
                    self.m_synthesizer.startSpeaking(message)
                }
            })
            .disposed(by: m_dispose_bag)
        
        btnSendImage?.rx.tap
            .subscribe(onNext: { [unowned self] in
                let img = self.btnSendImage?.image
                Popup_Viewer.shared()
                    .setupImage(img)
                    .show(self.findViewController())
            })
            .disposed(by: m_dispose_bag)
    }
}

