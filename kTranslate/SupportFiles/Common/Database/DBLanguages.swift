//
//  DBSupportLanguage.swift
//  kTranslate
//
//  Created by moon on 11/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Foundation
import FMDB

struct LanguageData {
    var idx:Int = -1
    var key:String?
    var name:String
    
    init(key:String?, name:String) {
        self.key = key
        self.name = name
    }
    
    init(result:FMResultSet) {
        self.idx = Int(result.int(forColumnIndex: 0))
        self.key = result.string(forColumnIndex: 1)
        self.name = result.string(forColumnIndex: 2) ?? ""
    }
}

class DBLanguages: DBManager {
    
    static let sql_create = ""
        + "CREATE TABLE IF NOT EXISTS \(DB_NAME.Languages) ("
        + "IDX INTEGER PRIMARY KEY AUTOINCREMENT, "
        + "KEY TEXT, en TEXT, ko TEXT );"
    
    public static func get(target:String, isSource:Bool) -> [LanguageData] {
        var datas:[LanguageData] = []
        if !db.open() { return datas }
        
        let sql = "SELECT IDX, KEY, \(target) FROM \(DB_NAME.Languages)"
        guard let result = db.executeQuery(sql, withArgumentsIn: []) else {
            print("Error \(db.lastErrorMessage())")
            db.close()
            return datas
        }
        
        while result.next() {
            let data = LanguageData(result: result)
            datas.append(data)
        }
        if isSource {
            let name = target == "ko" ? "언어감지" : "Detect"
            datas.insert(LanguageData(key: nil, name: name), at: 0)
        }
        
        db.close()
        return datas
    }
    
    public static func count() -> Int {
        var cnt:Int = 0;
        if !db.open() { return cnt }
        
        let sql = "SELECT COUNT(IDX) FROM \(DB_NAME.Languages)"
        guard let results = db.executeQuery(sql, withArgumentsIn:[]) else {
            print("Error \(db.lastErrorMessage())")
            db.close()
            return cnt
        }
        
        while results.next() {
            cnt = Int(results.int(forColumnIndex: 0))
            break
        }
        db.close()
        return cnt
    }
    
    @discardableResult
    public static func add(key:String, en:String, ko:String) -> Bool {
        if !db.open() { return false }
        
        let sql = "INSERT INTO \(DB_NAME.Languages) (KEY, en, ko) VALUES (?, ?, ?)"
        if !db.executeUpdate(sql, withArgumentsIn:[key, en, ko]) {
            print("Error \(db.lastErrorMessage())")
            db.close()
            return false
        }
        
        db.close()
        return true
    }
    
    public static func setup() {
        if self.count() != 0 { return }
        
        let arr_key:[String] = [
            "gl", "gu", "el", "nl", "ne", "no", "da", "de", "lo", "lv", "la", "ru", "ro", "lb", "lt", "mr", "mi", "mk", "mg", "ml", "ms", "mt", "mn", "hmn", "my", "eu", "vi", "be", "bn", "bs", "bg", "sm", "sr", "ceb", "st", "so", "sn", "su", "sw", "sv", "gd", "es", "sk", "sl", "sd", "si", "ar", "hy", "is", "ht", "ga", "az", "af", "sq", "am", "et", "eo", "en", "yo", "ur", "uz", "uk", "cy", "ig", "yi", "it", "id", "ja", "jw", "ka", "zu", "zh", "zh-TW", "ny", "cs", "kk", "ca", "kn", "co", "xh", "ku", "hr", "km", "ky", "tl", "ta", "tg", "th", "tr", "te", "ps", "pa", "fa", "pt", "pl", "fr", "fy", "fi", "haw", "ha", "ko", "hu", "iw", "hi"
        ]
        
        let arr_ko_name:[String] = [
            "갈리시아어", "구자라트어", "그리스어", "네덜란드어", "네팔어", "노르웨이어", "덴마크어", "독일어", "라오어", "라트비아어", "라틴어", "러시아어", "루마니아어", "룩셈부르크어", "리투아니아어", "마라티어", "마오리어", "마케도니아어", "말라가시어", "말라얄람어", "말레이어", "몰타어", "몽골어", "몽어", "미얀마어 (버마어)", "바스크어", "베트남어", "벨라루스어", "벵골어", "보스니아어", "불가리아어", "사모아어", "세르비아어", "세부아노", "세소토어", "소말리아어", "쇼나어", "순다어", "스와힐리어", "스웨덴어", "스코틀랜드 게일어", "스페인어", "슬로바키아어", "슬로베니아어", "신디어", "신할라어", "아랍어", "아르메니아어", "아이슬란드어", "아이티 크리올어", "아일랜드어", "아제르바이잔어", "아프리칸스어", "알바니아어", "암하라어", "에스토니아어", "에스페란토어", "영어", "요루바어", "우르두어", "우즈베크어", "우크라이나어", "웨일즈어", "이그보어", "이디시어", "이탈리아어", "인도네시아어", "일본어", "자바어", "조지아어", "줄루어", "중국어(간체)", "중국어(번체)", "체와어", "체코어", "카자흐어", "카탈로니아어", "칸나다어", "코르시카어", "코사어", "쿠르드어", "크로아티아어", "크메르어", "키르기스어", "타갈로그어", "타밀어", "타지크어", "태국어", "터키어", "텔루구어", "파슈토어", "펀자브어", "페르시아어", "포르투갈어", "폴란드어", "프랑스어", "프리지아어", "핀란드어", "하와이어", "하우사어", "한국어", "헝가리어", "히브리어", "힌디어"
        ]
        
        let arr_en_name:[String] = [
            "Afrikaans", "Albanian", "Amharic", "Arabic", "Armenian", "Azerbaijani", "Basque", "Belarusian", "Bengali", "Bosnian", "Bulgarian", "Catalan", "Cebuano", "Chichewa", "Chinese (Simplified)", "Chinese (Traditional)", "Corsican", "Croatian", "Czech", "Danish", "Dutch", "English", "Esperanto", "Estonian", "Filipino", "Finnish", "French", "Frisian", "Galician", "Georgian", "German", "Greek", "Gujarati", "Haitian Creole", "Hausa", "Hawaiian", "Hebrew", "Hindi", "Hmong", "Hungarian", "Icelandic", "Igbo", "Indonesian", "Irish", "Italian", "Japanese", "Javanese", "Kannada", "Kazakh", "Khmer", "Korean", "Kurdish (Kurmanji)", "Kyrgyz", "Lao", "Latin", "Latvian", "Lithuanian", "Luxembourgish", "Macedonian", "Malagasy", "Malay", "Malayalam", "Maltese", "Maori", "Marathi", "Mongolian", "Myanmar (Burmese)", "Nepali", "Norwegian", "Pashto", "Persian", "Polish", "Portuguese", "Punjabi", "Romanian", "Russian", "Samoan", "Scots Gaelic", "Serbian", "Sesotho", "Shona", "Sindhi", "Sinhala", "Slovak", "Slovenian", "Somali", "Spanish", "Sundanese", "Swahili", "Swedish", "Tajik", "Tamil", "Telugu", "Thai", "Turkish", "Ukrainian", "Urdu", "Uzbek", "Vietnamese", "Welsh", "Xhosa", "Yiddish", "Yoruba", "Zulu"
        ]
        
        for idx in 0..<arr_key.count {
            let key = arr_key[idx]
            let en = arr_en_name[idx]
            let ko = arr_ko_name[idx]
            self.add(key:key, en:en, ko:ko)
        }
    }
}
