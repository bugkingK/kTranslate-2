//
//  VMKakaoTranslate.swift
//  kTranslate
//
//  Created by moon on 30/08/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import RxAlamofire
import RxCocoa

class VMKakaoTranslate: NSObject {
    fileprivate let m_headers:[String:String] = [ "Authorization": "KakaoAK daab7870042dad08bdcbd6f37eaf8689" ]
    
    func translate(text:String, source:String, target:String) {
        var strUrl = "https://kapi.kakao.com/v1/translation/translate"
        strUrl.append("?src_lang=\(source)")
        strUrl.append("&target_lang=\(target)")
        strUrl.append("&query=\(text)")
        guard let urlTranslate = URL(string: strUrl.urlQueryAllowed()) else { return }
        _ = RxAlamofire.requestJSON(.post, urlTranslate, headers: m_headers)
            .debug()
            .subscribe(onNext: { (r, json) in
                
            }, onError: { (err) in
                print(err.localizedDescription)
            }, onCompleted: {
                
            }, onDisposed: {
                
            })
    }
}
