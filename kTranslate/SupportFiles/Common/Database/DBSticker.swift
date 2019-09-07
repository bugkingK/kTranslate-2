////
////  DBSticker.swift
////  kTranslate
////
////  Created by moon on 18/06/2019.
////  Copyright © 2019 bugking. All rights reserved.
////
//
//import Cocoa
//import FMDB
//
//struct StickerData {
//    var idx:Int = -1
//    /// 프로젝트와 join으로 연결된 idx값입니다.
//    var nIdxPJ:Int
//    var sContent:String
//    /// 프로젝트의 순서를 나타냅니다.
//    var nOrderSK:Int
//    var sCreatedDate:String
//
//    init(nIdxPJ:Int, sContent:String, nOrderSK:Int) {
//        self.nIdxPJ = nIdxPJ
//        self.sContent = sContent
//        self.nOrderSK = nOrderSK
//        self.sCreatedDate = CommonUtil.getCurrentDate()
//    }
//
//    init(datas:FMResultSet) {
//        self.idx = Int(datas.int(forColumnIndex: 0))
//        self.nIdxPJ = Int(datas.int(forColumnIndex: 1))
//        self.sContent = datas.string(forColumnIndex: 2) ?? ""
//        self.nOrderSK = Int(datas.int(forColumnIndex: 3))
//        self.sCreatedDate = datas.string(forColumnIndex: 4) ?? CommonUtil.getCurrentDate()
//    }
//}
//
//class DBSticker: DBManager {
//
//    fileprivate static let sql_select_sticker_arr = ""
//        + "SELECT * "
//        + "FROM \(DB_NAME.SK) "
//        + "WHERE JOIN_IDX_PJ=?"
//        + "ORDER BY ORDER_SK;"
//
//    fileprivate static let sql_select_sticker_cnt = ""
//        + "SELECT COUNT(IDX) "
//        + "FROM \(DB_NAME.SK) "
//        + "WHERE JOIN_IDX_PJ=?"
//
//    public static let sql_insert_sticker = ""
//        + "INSERT INTO \(DB_NAME.SK) "
//        + "(JOIN_IDX_PJ, CONTENT, ORDER_SK, DATE_CREATE) VALUES (?, ?, ?, ?);"
//
//    fileprivate static let sql_update_sticker = ""
//        + "UPDATE \(DB_NAME.SK) SET "
//        + "JOIN_IDX_PJ=?, "
//        + "CONTENT=?, "
//        + "ORDER_SK=?, "
//        + "DATE_CREATE=? "
//        + "WHERE IDX=?;"
//
//    fileprivate static let sql_delete_sticker = ""
//        + "DELETE FROM \(DB_NAME.SK) "
//        + "WHERE IDX=?;"
//
//    /*
//     excute
//     */
//    /// DB속 스티커의 모든 정보를 가져옵니다.
//    public static func getStickerList(idxPJ:Int) -> [StickerData] {
//        var datas:[StickerData] = []
//
//        if !db.open() {
//            return datas
//        }
//
//        guard let results = db.executeQuery(sql_select_sticker_arr, withArgumentsIn:[idxPJ]) else {
//            print("Error \(db.lastErrorMessage())")
//            db.close()
//            return datas
//        }
//
//        while results.next() {
//            let data = StickerData(datas: results)
//            datas.append(data)
//        }
//        db.close()
//        return datas
//    }
//    /// DB속 스티커의 갯수를 반환합니다.
//    public static func getStickerCnt(idxPJ:Int) -> Int {
//        var cnt:Int = 0;
//        if !db.open() {
//            return cnt
//        }
//
//        guard let results = db.executeQuery(sql_select_sticker_cnt, withArgumentsIn:[idxPJ]) else {
//            print("Error \(db.lastErrorMessage())")
//            db.close()
//            return cnt
//        }
//
//        while results.next() {
//            cnt = Int(results.int(forColumnIndex: 0))
//            break
//        }
//        db.close()
//        return cnt
//    }
//    /// Project가 생성되면 자동으로 스티커도 생성됩니다.
//    public static func addSticker(idxPJ:Int, content:String, orderSK:Int) -> Bool {
//        if !db.open() {
//            return false
//        }
//
//        //        let ctnSK = self.getStickerCnt(idxPJ: idxPJ)
//        if !db.executeUpdate(sql_insert_sticker, withArgumentsIn:[idxPJ, content, orderSK, CommonUtil.getCurrentDate()]) {
//            print("Error \(db.lastErrorMessage())")
//            db.close()
//            return false
//        }
//        db.close()
//        return true
//    }
//    /// 스티커의 값을 변경합니다.
//    public static func updateSticker(data:StickerData) -> Bool {
//        if !db.open() {
//            return false
//        }
//
//        if !db.executeUpdate(sql_update_sticker, withArgumentsIn:[data.nIdxPJ, data.sContent, data.nOrderSK, data.sCreatedDate, data.idx]) {
//            print("Error \(db.lastErrorMessage())")
//            db.close()
//            return false
//        }
//        db.close()
//        return true
//    }
//
//    public static func updateArraySticker(datas:[StickerData]) -> Bool {
//        if !db.open() {
//            return false
//        }
//
//        for data in datas {
//            if !db.executeUpdate(sql_update_sticker, withArgumentsIn:[data.nIdxPJ, data.sContent, data.nOrderSK, data.sCreatedDate, data.idx]) {
//                print("Error \(db.lastErrorMessage())")
//                db.close()
//                return false
//            }
//        }
//        db.close()
//        return true
//    }
//    /// idx에 해당하는 스티커를 삭제합니다.
//    public static func deleteSticker(idx:Int) -> Bool {
//        if !db.open() {
//            return false
//        }
//
//        if !db.executeUpdate(sql_delete_sticker, withArgumentsIn:[idx]) {
//            print("Error \(db.lastErrorMessage())")
//            db.close()
//            return false
//        }
//        db.close()
//        return true
//    }
//
//}
//
