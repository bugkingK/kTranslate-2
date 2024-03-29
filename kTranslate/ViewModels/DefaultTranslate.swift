//
//  VMKakaoTranslate.swift
//  kTranslate
//
//  Created by moon on 30/08/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import RxAlamofire
import RxCocoa
import RxSwift
import SwiftyJSON

enum TranslatorType:String {
    case google = "google"
    case papago = "papago"
    case kakao = "kakao"
    case kTranslate = "kTranslate"
}

struct TranslatorError {
    static let notSupport = "not Support"
    static let offToday = "I'm off today ~ See you tomorrow"
    static let reconnect = "An error occurred. Please try again in 1 minute."
    static let chooseTranslator = "Please select a translator in your preferences."
    static let notFoundChar = "No character found"
}

class DefaultTranslation:NSObject {
    struct TranslationData {
        var translatedText:String = ""
        
        fileprivate func convertJSON(data:Data) -> JSON? {
            do { return try JSON(data:data) }
            catch _ { return nil }
        }
        
        init(googleData:Data) {
            guard let json = self.convertJSON(data: googleData) else {
                translatedText = TranslatorError.reconnect
                return
            }
            
            var text = json["data"]["translations"][0]["translatedText"]
            translatedText = text.stringValue
            if translatedText == "" {
                translatedText = TranslatorError.notSupport
            }
        }
        
        init(kakaoData:Data) {
            guard let json = self.convertJSON(data: kakaoData) else {
                translatedText = TranslatorError.reconnect
                return
            }
            
            let arr_text = json["translated_text"].arrayValue
            for arr_element in arr_text {
                for element in arr_element.arrayValue {
                    translatedText.append(element.stringValue)
                }
                if arr_text.last != arr_element {
                    translatedText.append("\n")
                }
            }
            if translatedText == "" {
                translatedText = TranslatorError.notSupport
            }
        }
        
        init(papagoData:Data) {
            guard let json = self.convertJSON(data: papagoData) else {
                translatedText = TranslatorError.reconnect
                return
            }
            translatedText = json["message"]["result"]["translatedText"].stringValue
            if translatedText == "" {
                translatedText = TranslatorError.notSupport
            }
        }
    }
    
    var isActive:Bool = true
    var translatedText:PublishRelay<(String, TranslatorType)> = PublishRelay<(String, TranslatorType)>()
    func translate(text:String, source:String, target:String) {}
}

class GoogleTranslation: DefaultTranslation {
    fileprivate static let apiKey:String = "AIzaSyDkmnhTZ6NkD7F1o0HTHBsga33ZIql3PvU"
    fileprivate static let m_str_home = "https://translation.googleapis.com/language/translate/v2"
    
    override func translate(text:String, source:String, target:String) {
        if !isActive { return }
        if source == target {
            translatedText.accept((text, .google))
            return
        }
        
        var strUrl = GoogleTranslation.m_str_home
        strUrl.append("?key=\(GoogleTranslation.apiKey)")
        strUrl.append("&q=\(text)")
        strUrl.append("&source=\(source)")
        strUrl.append("&target=\(target)")
        strUrl.append("&format=text")
        
        guard let url = URL(string: strUrl.urlQueryAllowed()) else { return }
        _ = RxAlamofire.requestData(.post, url)
            .map { TranslationData(googleData: $0.1) }
            .subscribe(onNext: { (trans) in
                self.translatedText.accept((trans.translatedText, .google))
            }, onError: { (err) in
                self.translatedText.accept((TranslatorError.reconnect, .google))
            })
    }
}

class kTranslateTranslation: GoogleTranslation {
    override func translate(text: String, source: String, target: String) {
        if !isActive { return }
        if source == target {
            translatedText.accept((text, .kTranslate))
            return
        }
        
        var strConvertUrl = GoogleTranslation.m_str_home
        strConvertUrl.append("?key=\(GoogleTranslation.apiKey)")
        strConvertUrl.append("&q=\(text)")
        strConvertUrl.append("&source=\(source)")
        strConvertUrl.append("&target=ja")
        strConvertUrl.append("&format=text")
        
        guard let convertUrl = URL(string: strConvertUrl.urlQueryAllowed()) else { return }
        _ = RxAlamofire.requestData(.post, convertUrl)
            .map { TranslationData(googleData: $0.1) }
            .subscribe(onNext: { (trans) in
                if target == "ja" {
                    self.translatedText.accept((trans.translatedText, .kTranslate))
                    return
                }
                var strOriginUrl = GoogleTranslation.m_str_home
                strOriginUrl.append("?key=\(GoogleTranslation.apiKey)")
                strOriginUrl.append("&q=\(trans.translatedText)")
                strOriginUrl.append("&source=ja")
                strOriginUrl.append("&target=\(target)")
                strOriginUrl.append("&format=text")
                
                guard let originUrl = URL(string: strOriginUrl.urlQueryAllowed()) else { return }
                _ = RxAlamofire.requestData(.post, originUrl)
                    .map { TranslationData(googleData: $0.1) }
                    .subscribe(onNext: { (trans) in
                        self.translatedText.accept((trans.translatedText, .kTranslate))
                    }, onError: { (err) in
                        self.translatedText.accept((TranslatorError.reconnect, .kTranslate))
                    })
            }, onError: { (err) in
                self.translatedText.accept((TranslatorError.reconnect, .kTranslate))
            })
    }
}

class PapagoTranslation: DefaultTranslation {
    fileprivate let m_headers:[String:String] = [ "X-Naver-Client-Id": "GaKmnJWHqM7Sz64BXf2k",
                                                  "X-Naver-Client-Secret" : "5DSlLmNYxU" ]
    
    override func translate(text:String, source:String, target:String) {
        if !isActive { return }
        if source == target {
            translatedText.accept((text, .papago))
            return
        }
        
        let strUrl = "https://openapi.naver.com/v1/language/translate"
        _ = RxAlamofire.requestData(.post, strUrl, parameters: ["source":source, "target":target, "text":text], headers: m_headers)
            .map { TranslationData(papagoData: $0.1) }
            .subscribe(onNext: { (trans) in
                self.translatedText.accept((trans.translatedText, .papago))
            }, onError: { (err) in
                self.translatedText.accept((TranslatorError.reconnect, .papago))
            })
    }
}


class KakaoTranslation: DefaultTranslation {
    fileprivate let m_headers:[String:String] = [ "Authorization": "KakaoAK daab7870042dad08bdcbd6f37eaf8689" ]
    
    override func translate(text:String, source:String, target:String) {
        if !isActive { return }
        if source == target {
            translatedText.accept((text, .kakao))
            return
        }
        
        let v_source = convert(source: source)
        let v_target = convert(source: target)
        var strUrl = "https://kapi.kakao.com/v1/translation/translate"
        strUrl.append("?src_lang=\(v_source)")
        strUrl.append("&target_lang=\(v_target)")
        strUrl.append("&query=\(text)")
        guard let url = URL(string: strUrl.urlQueryAllowed()) else { return }
        _ = RxAlamofire.requestData(.post, url, headers: m_headers)
            .map { TranslationData(kakaoData: $0.1) }
            .subscribe(onNext: { (trans) in
                self.translatedText.accept((trans.translatedText, .kakao))
            }, onError: { (err) in
                self.translatedText.accept((err.localizedDescription, .kakao))
            })
    }
    
    fileprivate func convert(source:String) -> String {
        switch source {
        case "ko": return "kr"
        case "ja": return "jp"
        case "zh", "zh-TW": return "cn"
        default: return source
        }
    }
}

extension String {
    func urlQueryAllowed() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
}

extension GoogleTranslation {
    struct DetectData {
        var confidence:Int = 1
        var isReliable:Bool = false
        var source:String = "und"
        init(data:Data) {
            do {
                let json = try JSON(data: data)
                var dic = json["data"]["detections"][0][0]
                confidence = dic["confidence"].intValue
                isReliable = dic["isReliable"].boolValue
                source = dic["language"].stringValue
                if source == "und" {
                    source = "en"
                }
            } catch let err {
                print(err.localizedDescription)
            }
        }
    }
    
    struct SupportData {
        var languages:[(name:String, key:String?)] = []
        
        init(data:Data) {
            let json = try! JSON(data: data)
            let languages = json["data"]["languages"].arrayValue
            for language in languages {
                self.languages.append((language["name"].stringValue, language["language"].stringValue))
            }
        }
    }
    
    static func detect(text:String) -> Observable<DetectData>? {
        var strUrl = GoogleTranslation.m_str_home
        strUrl.append("/detect")
        strUrl.append("?key=\(GoogleTranslation.apiKey)")
        strUrl.append("&q=\(text)")
        
        guard let url = URL(string: strUrl.urlQueryAllowed()) else { return nil }
        return RxAlamofire.requestData(.post, url)
            .map { DetectData(data:$0.1) }
    }
    
    static func supportLanguages(target:String) -> Observable<SupportData>? {
        var strUrl = GoogleTranslation.m_str_home
        strUrl.append("/languages")
        strUrl.append("?key=\(GoogleTranslation.apiKey)")
        strUrl.append("&target=\(target)")
        
        guard let url = URL(string: strUrl.urlQueryAllowed()) else { return nil }
        return RxAlamofire.requestData(.get, url)
            .map { SupportData(data: $0.1) }
    }
    
    struct DetectImageData {
        var text:String?
        init(data:Data) {
            let json = try! JSON(data: data)
            let responses = json["responses"].arrayValue
            for res in responses {
                guard let fullTextAnnotation = res.dictionaryValue["fullTextAnnotation"]?.dictionaryValue else { continue }
                text = fullTextAnnotation["text"]?.stringValue
            }
        }
    }
    
    static func detect(image:NSImage) -> Observable<DetectImageData>? {
        var strUrl = "https://vision.googleapis.com/v1/images:annotate"
        strUrl.append("?key=\(GoogleTranslation.apiKey)")
        
        guard let url = URL(string: strUrl.urlQueryAllowed()) else { return nil }
        var request = URLRequest(url: url)
        guard let base64image = image.base64String else { return nil }
        
        let json: [String: Any] = [
            "requests" : [
                "image" : [
                    "content":base64image
                ],
                "features" : [
                    "type" : "TEXT_DETECTION"
                ]
            ]
        ]
        
        let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        request.httpBody = data
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return RxAlamofire.requestData(request)
            .map { DetectImageData(data: $0.1) }
    }
}

extension NSImage {
    var base64String: String? {
        guard let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .calibratedRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
            ) else {
                print("Couldn't create bitmap representation")
                return nil
        }
        
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        draw(at: NSZeroPoint, from: NSZeroRect, operation: .sourceOver, fraction: 1.0)
        NSGraphicsContext.restoreGraphicsState()
        
        guard let data = rep.representation(using: NSBitmapImageRep.FileType.png, properties: [NSBitmapImageRep.PropertyKey.compressionFactor: 1.0]) else {
            print("Couldn't create PNG")
            return nil
        }
        
        // With prefix
        // return "data:image/png;base64,\(data.base64EncodedString(options: []))"
        // Without prefix
        return data.base64EncodedString(options: [])
    }
}
