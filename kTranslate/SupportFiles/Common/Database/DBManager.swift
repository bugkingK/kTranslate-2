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
        static let UseHistory = "UseHistory"
        static let Languages = "Languages"
    }
    
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
        
        let createDB = [DBUseHistory.sql_create, DBLanguages.sql_create]
        for sql in createDB {
            if !db.executeStatements(sql) {
                print("Error \(db.lastErrorMessage())")
            }
        }
        
        db.close()
        return db
    }()
}



