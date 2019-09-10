//
//  ChattingCell.swift
//  kTranslate
//
//  Created by bugking on 10/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa
import RxSwift

class ChattingCell:NSTableCellView {
    @IBOutlet weak var imgProfile:NSImageView?
    @IBOutlet weak var lbName:NSTextField?
    @IBOutlet weak var lbMessage:NSTextField?
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

