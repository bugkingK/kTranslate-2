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
    var strMessage:String = ""
    var imgMessage:NSImage?
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
    
    init(imgMessage:NSImage, type:TYPE) {
        self.imgMessage = imgMessage
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
    
    public func clean() {
        m_arr_datas = []
        m_source_presenter.clean()
        m_target_presenter.clean()
        m_dispose_bag = DisposeBag()
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
    fileprivate let m_limiter:Limiter = Limiter(interval: 3)
    
    fileprivate var m_arr_cell_identifiers = ["ChattingSendCell", "ChattingReciveCell", "ChattingSendImageCell"]
    fileprivate var m_arr_datas:[ChattingData] = [] {
        didSet {
            m_tv_main.reloadData()
            m_tv_main.scrollToEndOfDocument(self)
        }
    }
    
    fileprivate func setupLayout() {
        m_tv_main.delegate = self
        m_tv_main.dataSource = self
        m_tv_main.registerForDraggedTypes([.png, .fileURL, .URL])
        for identifier in m_arr_cell_identifiers {
            let cellNib = NSNib(nibNamed: identifier, bundle: nil)
            m_tv_main.register(cellNib, forIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier))
        }
        
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
            .subscribe(onNext: { str in
                let prevPoint = self.m_ttv_input.selectedRange()
                self.m_ttv_input.string = str
                self.m_ttv_input.selectedRanges = [prevPoint] as [NSValue]
            })
            .disposed(by: m_dispose_bag)
    }
    
    fileprivate func onClickBtnSend() {
        if m_limiter.allow() {
            let text = self.m_ttv_input.string
            if text != "" {
                let data = ChattingData(message: text, type: .Me)
                self.m_arr_datas.append(data)
                self.m_ttv_input.string = ""
                self.m_translator.run(text: text, source: m_sel_source, target: m_sel_target)
            }
            DBUseHistory.add(content: text)
            Analyst.shared.track(event: .translate)
            m_limiter.start()
        } else {
            self.toast(message: "Request more slowly, please. 😭")
        }
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
            self.m_btn_source.title = sel.name
            self.m_sel_source = sel.key
            self.m_source_presenter.popup_dismiss()
        })
        
        let targetVC = NSStoryboard.make(sbName: "Main", vcName: "Main_ChooseLanguage") as! Main_ChooseLanguage
        targetVC.setup(select:"en", isSource: false, selBlock: { [unowned self] sel in
            self.m_btn_target.title = sel.name
            self.m_sel_target = sel.key!
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
        
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init(identifier), owner: self) as? ChattingCell else {
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
            cell.btnSendImage?.image = item.imgMessage
        }
        
        return cell
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        m_vw_drag_drop.isHidden = false
        return NSDragOperation.generic
    }
}

extension Main_Chatting: ADragDropViewDelegate {
    func dragDropView(_ draggingEntered: ADragDropView, draggingInfo: NSDraggingInfo) {
        PopoverController.shared.isDragging = true
    }
    
    func dragDropView(_ draggingExited: ADragDropView) {
        m_vw_drag_drop.isHidden = true
        PopoverController.shared.isDragging = false
    }
    func dragDropView(_ dragDropView: ADragDropView, droppedFileWithURL URL: URL) {
        m_vw_drag_drop.isHidden = true
        PopoverController.shared.isDragging = false
        guard let v_img = NSImage(contentsOf: URL) else { return }
        let data = ChattingData(imgMessage: v_img, type: .Image)
        self.m_arr_datas.append(data)
        m_translator.run(image: v_img, target: m_sel_target)
    }
    
    func dragDropView(_ dragDropView: ADragDropView, droppedFilesWithURLs URLs: [URL]) {
        m_vw_drag_drop.isHidden = true
        PopoverController.shared.isDragging = false
        self.toast(message: "Please pass only one image")
    }
    
    func dragDropView(_ dragDropView: ADragDropView, droppedFileImage image: NSImage) {
        m_vw_drag_drop.isHidden = true
        PopoverController.shared.isDragging = false
        let data = ChattingData(imgMessage: image, type: .Image)
        self.m_arr_datas.append(data)
        m_translator.run(image: image, target: m_sel_target)
    }
}
