//
//  SQLInterface.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 11. 26..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import Foundation

enum SQLError: Error {
    case connectionError
    case queryError
    case otherError
}

class SQLInterface {
    lazy var db:OpaquePointer? = {
        var _db:OpaquePointer? = nil
        let dbPath = Bundle.main.path(forResource: "coupon", ofType:"db")
        if sqlite3_open(dbPath, &_db) == SQLITE_OK {
            return _db
        }
        print("Fail to connect database..")
        abort()
    }()
    var stmt:OpaquePointer? = nil
    
    init() {
    }
    
    deinit {
        if let db = db {
            sqlite3_close(db)
        }
    }
    
    // 회원 쿠폰 데이터 가져오기
    func selectUserCouponData(_ userId:Int) throws -> [UserCouponModel?]?  {
        guard db != nil else { throw SQLError.connectionError }
        defer { sqlite3_finalize(stmt) }
        var userCouponList:[UserCouponModel?]? =  [UserCouponModel]()
        let query = "select idx,merchant_idx,coupon_count from coupon where user_idx = \(userId)"
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let merchantIdx:Int32 = sqlite3_column_int(stmt, 1)
                let couponCount:Int32 = sqlite3_column_int(stmt, 2)
                
                let userCouponModel:UserCouponModel? = UserCouponModel()
                userCouponModel?.merchantId = Int(merchantIdx)
                userCouponModel?.couponCount = Int(couponCount)
                userCouponList?.append(userCouponModel)
            }
        } else {
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print(errorMessage)
        }
        return userCouponList
    }
    
    // 회원 쿠폰 횟수 업데이트
    func updateCouponCount(_  userId:Int, _ merchantId:Int, _ couponCount:Int, complete: () -> Void) throws {
        guard db != nil else { throw SQLError.connectionError }
        defer { sqlite3_finalize(stmt) }
        let query = "update coupon set coupon_count = \(couponCount)  where user_idx = \(userId) and merchant_idx = \(merchantId)"
        print(query)
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Success update")
                complete()
            } else {
                print("Fail update")
            }
        } else {
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print(errorMessage)
        }
    }
    
    // 가맹점 데이터 가져오기
    func selectMerchantData() throws -> [MerchantModel?]?  {
        guard db != nil else { throw SQLError.connectionError }
        defer { sqlite3_finalize(stmt) }
        var merchatList:[MerchantModel?]? =  [MerchantModel]()
        let query = "select idx,name,content,max_coupon_count from merchant"
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let merchantIdx:Int32 = sqlite3_column_int(stmt, 0)
                let name = sqlite3_column_text(stmt, 1)
                let maxCouponCount:Int32 = sqlite3_column_int(stmt, 3)
                
                let merchantModel:MerchantModel? = MerchantModel()
                merchantModel?.merchantId = Int(merchantIdx)
                merchantModel?.name = String(cString: name!)
                merchantModel?.maxCouponCount = Int(maxCouponCount)
                merchatList?.append(merchantModel)
            }
        } else {
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print(errorMessage)
        }
        return merchatList
    }
    
    
    /*
    func insert_value(value: Int32) throws {
        defer { sqlite3_finalize(stmt) }
        let query = "INSERT INTO test (id) VALUES (?)"
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_int(stmt, 1, value)
            if sqlite3_step(stmt) == SQLITE_DONE { return }
        }
        throw SQLError.QueryError
     }
 
 
    func get_values() throws -> [Int32] {
        guard db != nil else { throw SQLError.ConnectionError }
        defer { sqlite3_finalize(stmt) }
        var result = [Int32]()
        let query = "SELECT * FROM test"
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let i:Int32 = sqlite3_column_int(stmt, 0)
                result.append(i)
            }
            return result
        }
        throw SQLError.QueryError
    }
     */
}
