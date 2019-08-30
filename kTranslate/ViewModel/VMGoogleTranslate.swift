//
//  VMGoogleTranslate.swift
//  kTranslate
//
//  Created by moon on 29/08/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import RxAlamofire
import RxCocoa

class VMGoogleTranslate: NSObject {
    
    fileprivate var apiKey:String = "AIzaSyDkmnhTZ6NkD7F1o0HTHBsga33ZIql3PvU"
    fileprivate let m_str_home = "https://translation.googleapis.com/language/translate/v2"
    
    func supportLanguages() {
        var strUrl = m_str_home
        strUrl.append("/languages")
        strUrl.append("?key=\(self.apiKey)")
        
        guard let urlTranslate = URL(string: strUrl.urlQueryAllowed()) else { return }
        _ = RxAlamofire.requestJSON(.get, urlTranslate)
            .debug()
            .subscribe(onNext: { (r, json) in
                
            }, onError: { (err) in
                
            }, onDisposed: {
                
            })
    }
    
    func detect(text:String) {
        var strUrl = m_str_home
        strUrl.append("/detect")
        strUrl.append("?key=\(self.apiKey)")
        strUrl.append("&q=\(text)")
        guard let urlTranslate = URL(string: strUrl.urlQueryAllowed()) else { return }
        _ = RxAlamofire.requestJSON(.post, urlTranslate)
            .debug()
            .subscribe(onNext: { (r, json) in
                
            }, onError: { (err) in
                
            }, onDisposed: {
                
            })
    }
    
    func translate(text:String, source:String, target:String) {
        var strUrl = m_str_home
        strUrl.append("?key=\(self.apiKey)")
        strUrl.append("&q=\(text)")
        strUrl.append("&source=\(source)")
        strUrl.append("&target=\(target)")
        strUrl.append("&format=text")
        
        guard let urlTranslate = URL(string: strUrl.urlQueryAllowed()) else { return }
        _ = RxAlamofire.requestJSON(.post, urlTranslate)
            .debug()
            .subscribe(onNext: { (r, json) in
                
            }, onError: { (err) in
                
            }, onDisposed: {
                
            })
    }
}

extension String {
    func urlQueryAllowed() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
}
