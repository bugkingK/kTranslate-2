//
//  VMPapagoTranslate.swift
//  kTranslate
//
//  Created by moon on 30/08/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import RxAlamofire
import RxCocoa

class VMPapagoTranslate: NSObject {
    fileprivate let m_headers:[String:String] = [ "X-Naver-Client-Id": "GaKmnJWHqM7Sz64BXf2k",
                                                  "X-Naver-Client-Secret" : "5DSlLmNYxU" ]
    
    func translate(text:String, source:String, target:String) {
        let strUrl = "https://openapi.naver.com/v1/language/translate"
        _ = RxAlamofire.requestJSON(.post, strUrl, parameters: ["source":source, "target":target, "text":text], headers: m_headers)
            .debug()
            .subscribe(onNext: { (r, json) in
                
            }, onError: { (err) in
                print(err.localizedDescription)
            }, onCompleted: {
                
            }, onDisposed: {
                
            })
    }
}
