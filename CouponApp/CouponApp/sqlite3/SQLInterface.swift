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
                
                var userCouponModel:UserCouponModel = UserCouponModel()
                userCouponModel.merchantId = Int(merchantIdx)
                userCouponModel.couponCount = Int(couponCount)
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
    
    //회원 쿠폰 삭제
    func deleteCounpon(_  userId:Int, _ merchantId:Int, complete: () -> Void) throws {
        guard db != nil else { throw SQLError.connectionError }
        defer { sqlite3_finalize(stmt) }
        let query = "delete from coupon where user_idx = \(userId) and merchant_idx = \(merchantId)"
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Success delete")
                complete()
            } else {
                print("Fail delete")
            }
        } else {
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print(errorMessage)
        }
    }
    
    //회원 쿠폰 등록
    func insertCoupon(_  userId:Int, _ merchantId:Int, complete: () -> Void) throws {
        guard db != nil else { throw SQLError.connectionError }
        defer { sqlite3_finalize(stmt) }
        let query = "insert into coupon (merchant_idx, user_idx, coupon_count) values (\(merchantId),\(userId),0)"
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Success insert")
                complete()
            } else {
                print("Fail insert")
            }
        } else {
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print(errorMessage)
        }
    }
    
    //회원 쿠폰 여부
    func isUserCoupon(_  userId:Int, _ merchantId:Int) throws -> Bool {
        guard db != nil else { throw SQLError.connectionError }
        defer { sqlite3_finalize(stmt) }
        let query = "select COUNT(idx) from coupon where user_idx = \(userId) and merchant_idx = \(merchantId)"
        var count = 0
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            while( sqlite3_step(stmt) == SQLITE_ROW )
            {
                count = Int(sqlite3_column_int(stmt, 0))
            }
            if count > 0 {
                return true
            }
        }
        return false
    }
    
    // 가맹점 데이터 가져오기
    func selectMerchantData() throws -> [MerchantModel?]?  {
        guard db != nil else { throw SQLError.connectionError }
        defer { sqlite3_finalize(stmt) }
        var merchatList:[MerchantModel?]? =  [MerchantModel]()
        let query = "select idx,name,content,max_coupon_count, image_url, latitude, longitude from merchant"
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let merchantIdx:Int32 = sqlite3_column_int(stmt, 0)
                let name = sqlite3_column_text(stmt, 1)
                let content = sqlite3_column_text(stmt, 2)
                let maxCouponCount:Int32 = sqlite3_column_int(stmt, 3)
                let imageUrl = sqlite3_column_text(stmt, 4)
                let latitude = sqlite3_column_double(stmt, 5)
                let longitude = sqlite3_column_double(stmt, 6)
                
                var merchantModel:MerchantModel = MerchantModel()
                merchantModel.merchantId = Int(merchantIdx)
                merchantModel.name = String(cString: name!)
                merchantModel.content = String(cString: content!)
                merchantModel.maxCouponCount = Int(maxCouponCount)
                merchantModel.logoImageUrl = String(cString:imageUrl!)
                merchantModel.latitude = latitude
                merchantModel.longitude = longitude
                merchatList?.append(merchantModel)
            }
        } else {
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print(errorMessage)
        }
        return merchatList
    }

}
