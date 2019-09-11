//
//  Translator.swift
//  Translate-Text
//
//  Created by moon on 02/09/2019.
//  Copyright © 2019 Bugking. All rights reserved.
//

import Foundation
import RxCocoa

class Translator:NSObject {
    
    override init() {
        super.init()
        m_arr_trans = [google, papago, kakao, kTranslate]
    }
    
    fileprivate var m_arr_trans:[DefaultTranslation]!
    public let google:GoogleTranslation = GoogleTranslation()
    public let papago:PapagoTranslation = PapagoTranslation()
    public let kakao:KakaoTranslation = KakaoTranslation()
    public let kTranslate:kTranslateTranslation = kTranslateTranslation()
    public var meText:PublishRelay<String> = PublishRelay<String>()
    
    func run(text:String, source:String?, target:String) {
        if !isActive() {
            meText.accept(TranslatorError.chooseTranslator)
            return
        }
        
        if let v_source = source {
            for trans in self.m_arr_trans {
                trans.translate(text: text, source: v_source, target: target)
            }
        } else {
            guard let obsDetect = GoogleTranslation.detect(text: text) else {
                meText.accept(TranslatorError.reconnect)
                return
            }
            
            _ = obsDetect.subscribe(onNext: { [unowned self] (detect) in
                for trans in self.m_arr_trans {
                    trans.translate(text: text, source: detect.source, target: target)
                }
            }, onError: { [unowned self] (err) in
                self.meText.accept(TranslatorError.reconnect)
            })
        }
    }
    
    func run(image:NSImage, target:String) {
        if !isActive() {
            meText.accept(TranslatorError.chooseTranslator)
            return
        }
        guard let obsDetect = GoogleTranslation.detect(image: image) else {
            meText.accept(TranslatorError.reconnect)
            return
        }
        
        _ = obsDetect.subscribe(onNext: { [unowned self ](detect) in
                guard let v_text = detect.text else {
                    self.meText.accept(TranslatorError.notFoundChar)
                    return
                }
                self.meText.accept(v_text)
                self.run(text: v_text, source: nil, target: target)
            }, onError: { (err) in
                self.meText.accept(TranslatorError.reconnect)
            }, onDisposed: {
                // 다이얼 로그 ...
            })
    }
    
    fileprivate func isActive() -> Bool {
        var count = 0
        for trans in m_arr_trans {
            if trans.isActive {
                count += 1
            }
        }
        
        return count != 0
    }
    
}
