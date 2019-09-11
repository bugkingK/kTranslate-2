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
            datas.insert(LanguageData(key: nil, name: "Detect"), at: 0)
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
    
    public static func setup() {
        if self.count() != 0 { return }
        
        
        
    }
}
