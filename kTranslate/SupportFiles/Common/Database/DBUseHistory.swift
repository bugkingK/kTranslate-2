//
//  DBUseHistory.swift
//  kTranslate
//
//  Created by bugking on 07/09/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa
import FMDB

struct UseHistoryData {
    var idx:Int = -1
    var sContent:String
    var sCreatedDate:String
    
    init(content:String) {
        self.sContent = content
        self.sCreatedDate = CommonUtil.getCurrentDate()
    }
    
    init(result:FMResultSet) {
        self.idx = Int(result.int(forColumnIndex: 0))
        self.sContent = result.string(forColumnIndex: 1) ?? ""
        self.sCreatedDate = result.string(forColumnIndex: 2) ?? CommonUtil.getCurrentDate()
    }
}

class DBUseHistory: DBManager {
    
    static let sql_create = ""
        + "CREATE TABLE IF NOT EXISTS \(DB_NAME.UseHistory) ("
        + "IDX INTEGER PRIMARY KEY AUTOINCREMENT, "
        + "CONTENT TEXT, "
        + "DATE_CREATE TEXT "
        + ");"
    
    public static func get(limit:Int? = nil) -> [UseHistoryData] {
        var datas:[UseHistoryData] = []
        if !db.open() { return datas }
        let strLimit = limit == nil ? "" : "LIMIT \(limit!)"
        
        let sql = "SELECT * FROM \(DB_NAME.UseHistory) ORDER BY IDX DESC \(strLimit)"
        guard let result = db.executeQuery(sql, withArgumentsIn: []) else {
            print("Error \(db.lastErrorMessage())")
            db.close()
            return datas
        }
        
        while result.next() {
            let data = UseHistoryData(result: result)
            datas.append(data)
        }
        db.close()
        return datas
    }
    
    @discardableResult
    public static func add(content:String) -> Bool {
        if !db.open() { return false }
        
        let sql = "INSERT INTO \(DB_NAME.UseHistory) (CONTENT, DATE_CREATE) VALUES (?, ?)"
        if !db.executeUpdate(sql, withArgumentsIn:[content, CommonUtil.getCurrentDate()]) {
            print("Error \(db.lastErrorMessage())")
            db.close()
            return false
        }
        
        db.close()
        return true
    }
    
    @discardableResult
    public static func update(data:UseHistoryData) -> Bool {
        if !db.open() { return false }

        let sql = "UPDATE \(DB_NAME.UseHistory) SET CONTENT=?, DATE_CREATE=? WHERE IDX=?"
        if !db.executeUpdate(sql, withArgumentsIn:[data.sContent, data.sCreatedDate, data.idx]) {
            print("Error \(db.lastErrorMessage())")
            db.close()
            return false
        }
        db.close()
        return true
    }
    
    @discardableResult
    public static func deleteSticker(idx:Int) -> Bool {
        if !db.open() { return false }

        let sql = "DELETE FROM \(DB_NAME.UseHistory) WHERE IDX=?"
        if !db.executeUpdate(sql, withArgumentsIn:[idx]) {
            print("Error \(db.lastErrorMessage())")
            db.close()
            return false
        }
        db.close()
        return true
    }


}
