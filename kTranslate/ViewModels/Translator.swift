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
    
    func run(text:String, source:String?, target:String) {
        if let v_source = source {
            for trans in self.m_arr_trans {
                trans.translate(text: text, source: v_source, target: target)
            }
        } else {
            GoogleTranslation.detect(text: text) { [weak self] (detect) in
                guard let `self` = self else { return }
                for trans in self.m_arr_trans {
                    trans.translate(text: text, source: detect.source, target: target)
                }
            }
        }
    }
    
}
/*
 한국어    kr
 영어    en
 일본어    jp
 중국어    cn
 베트남어    vi
 인도네시아어    id
 아랍어    ar
 뱅갈어    bn
 독일어    de
 스페인어    es
 프랑스어    fr
 힌디어    hi
 이탈리아어    it
 말레이시아어    ms
 네덜란드어    nl
 포르투갈어    pt
 러시아어    ru
 태국어    th
 터키어    tr
 */
