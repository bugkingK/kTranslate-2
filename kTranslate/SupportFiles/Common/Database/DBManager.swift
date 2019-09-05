//
//  DBManager.swift
//  kTranslate
//
//  Created by moon on 18/06/2019.
//  Copyright © 2019 bugking. All rights reserved.
//

import Cocoa
import FMDB

class DBManager: NSObject {
    fileprivate static let str_db_name:String = "apps.db"
    
    public enum DB_NAME {
        static let SK = "STICKER"
    }
    
    fileprivate static let sql_create_sticker = ""
        + "CREATE TABLE IF NOT EXISTS \(DB_NAME.SK) ("
        + "IDX INTEGER PRIMARY KEY AUTOINCREMENT, "
        + "JOIN_IDX_PJ INTEGER, "
        + "CONTENT TEXT, "
        + "ORDER_SK INTEGER, "
        + "DATE_CREATE TEXT "
        + ");"
    
    internal static var db:FMDatabase = {
        let path_application = FileManager.default.urls(for: .documentationDirectory, in: .userDomainMask).first!
        let directory_db = path_application.appendingPathComponent("db")
        
        if !FileManager.default.fileExists(atPath: directory_db.path) {
            do {
                try FileManager.default.createDirectory(at: directory_db, withIntermediateDirectories: true, attributes: nil)
            } catch let err {
                print(err)
            }
        }
        
        let dbPath = directory_db.path.appending("/\(str_db_name)")
        
        // 데이터베이스 파일이 존재하지 않으면 데이터베이스 파일 생성
        let db = FMDatabase(path: dbPath)
        
        if FileManager.default.fileExists(atPath: dbPath) {
            return db
        }
        
        if !db.open() {
            print("Error \(db.lastErrorMessage())")
            return db
        }
        
        if !db.executeStatements(sql_create_sticker) {
            print("Error \(db.lastErrorMessage())")
        }
        
        let menu = "Press the +button and leave a brief note. \n\n You can change the note by double-clicking it and add, change, or delete it when you right-click it."
        
        if !db.executeUpdate(DBSticker.sql_insert_sticker, withArgumentsIn:[0, menu, 0, CommonUtil.getCurrentDate()]) {
            print("Error \(db.lastErrorMessage())")
        }
        
        db.close()

        return db
    }()
    
    static public func reloadDB() {
        let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
        let path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString
        let task = Process()
        task.launchPath = "/usr/bin/open"
        task.arguments = [path]
        task.launch()
        exit(0)
        
    }
}



