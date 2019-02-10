//
//  SQLInterface.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 11. 26..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit

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
    
    //회원가입
    func insertUser(phoneNumber:String, password:String, name:String, complete:@escaping CouponBaseCallBack) throws {
        guard db != nil else { throw SQLError.connectionError }
        defer { sqlite3_finalize(stmt) }
        let query = "insert into user (phone_number,user_pwd,name) values ('\(phoneNumber)','\(password)','\(name)')"
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                complete(true)
            } else {
                print("Fail insert")
                // complete(false)
            }
        } else {
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print(errorMessage)
            // complete(false)
        }
    }
    
    //회원 데이터 가져 오기
    func selectUserData(phoneNumber:String) throws -> Int {
        guard db != nil else { throw SQLError.connectionError }
        defer { sqlite3_finalize(stmt) }
        var userId:Int = 0
        let query = "select idx from user where phone_number = '\(phoneNumber)'"
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                userId = Int(sqlite3_column_int(stmt,0))
                break;
            }
        } else {
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print(errorMessage)
        }
        return userId
    }
    
    func selectUserData(phoneNumber:String, password:String) throws -> Int {
        guard db != nil else { throw SQLError.connectionError }
        defer { sqlite3_finalize(stmt) }
        var userId:Int = 0
        let query = "select idx from user where phone_number = '\(phoneNumber)' and user_pwd = '\(password)'"
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                userId = Int(sqlite3_column_int(stmt,0))
                break;
            }
        } else {
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print(errorMessage)
        }
        return userId
    }
    
    // 회원 쿠폰 데이터 가져오기
    func selectUserCouponData(_ userId:Int) throws -> UserCouponListModel?  {
        guard db != nil else { throw SQLError.connectionError }
        defer { sqlite3_finalize(stmt) }
        let query = "select idx,merchant_idx,coupon_count from coupon where user_idx = \(userId)"
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            var userCouponList:UserCouponListModel? = UserCouponListModel()
            while sqlite3_step(stmt) == SQLITE_ROW {
                let merchantIdx:Int32 = sqlite3_column_int(stmt, 1)
                let couponCount:Int32 = sqlite3_column_int(stmt, 2)
                
                let userCouponModel:UserCouponModel = UserCouponModel()
                userCouponModel.merchantId = Int(merchantIdx)
                userCouponModel.couponCount = Int(couponCount)
                userCouponList?.append(userCouponModel)
            }
            return userCouponList
        } else {
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print(errorMessage)
            return nil
        }
    }
    
    // 회원 쿠폰 횟수 업데이트
    func updateCouponCount(_  userId:Int, _ merchantId:Int, _ couponCount:Int, complete:@escaping CouponBaseCallBack) throws {
        guard db != nil else { throw SQLError.connectionError }
        defer { sqlite3_finalize(stmt) }
        let query = "update coupon set coupon_count = \(couponCount)  where user_idx = \(userId) and merchant_idx = \(merchantId)"
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Success update")
                complete(true)
            } else {
                print("Fail update")
                complete(false)
            }
        } else {
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print(errorMessage)
        }
    }
    
    //회원 쿠폰 삭제
    func deleteCounpon(_  userId:Int, _ merchantId:Int, complete:@escaping CouponBaseCallBack) throws {
        guard db != nil else { throw SQLError.connectionError }
        defer { sqlite3_finalize(stmt) }
        let query = "delete from coupon where user_idx = \(userId) and merchant_idx = \(merchantId)"
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Success delete")
                complete(true)
            } else {
                print("Fail delete")
                complete(false)
            }
        } else {
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print(errorMessage)
            complete(false)
        }
    }
    
    //회원 쿠폰 등록
    func insertCoupon(_  userId:Int, _ merchantId:Int, complete:@escaping CouponBaseCallBack) throws {
        guard db != nil else { throw SQLError.connectionError }
        defer { sqlite3_finalize(stmt) }
        let query = "insert into coupon (merchant_idx, user_idx, coupon_count) values (\(merchantId),\(userId),0)"
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Success insert")
                complete(true)
            } else {
                print("Fail insert")
                complete(false)
            }
        } else {
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print(errorMessage)
            complete(false)
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
    func selectMerchantData() throws -> MerchantListModel?  {
        guard db != nil else { throw SQLError.connectionError }
        defer { sqlite3_finalize(stmt) }
        let query = "select idx,name,content, image_url, latitude, longitude, is_couponImage, card_background from merchant"
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            var merchatList:MerchantListModel? = MerchantListModel()
            while sqlite3_step(stmt) == SQLITE_ROW {
                let merchantIdx:Int32 = sqlite3_column_int(stmt, 0)
                let name = sqlite3_column_text(stmt, 1)
                let content = sqlite3_column_text(stmt, 2)
                let imageUrl = sqlite3_column_text(stmt, 3)
                let latitude = sqlite3_column_double(stmt, 4)
                let longitude = sqlite3_column_double(stmt, 5)
                let isCouponImage = sqlite3_column_int(stmt, 6)
                let cardBackground = sqlite3_column_text(stmt, 7)

                var merchantModel:MerchantModel = MerchantModel()
                merchantModel.merchantId = Int(merchantIdx)
                merchantModel.name = String(cString: name!)
                merchantModel.content = String(cString: content!)
                merchantModel.isCouponImage = (isCouponImage > 0)
                merchantModel.logoImageUrl = String(cString:imageUrl!)
                merchantModel.latitude = latitude
                merchantModel.longitude = longitude
                merchantModel.cardBackGround = String(cString: cardBackground!)
                merchatList?.list.append(merchantModel)
            }
            return merchatList
        } else {
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print(errorMessage)
            return nil
        }
    }
    
    // 가맹점 - 쿠폰 정보 가져오기 ( DRAW용 )
    func selectDrawCouponData(merchantId:Int) throws -> [DrawCouponModel] {
        guard db != nil else { throw SQLError.connectionError }
        defer { sqlite3_finalize(stmt) }
        var drawCouponList:[DrawCouponModel] =  [DrawCouponModel]()
        var query = "select merchant_idx, coupon_idx, circle_color, ring_color,ring_thickness, is_ring, checkline_width, checkline_color, is_event"
        query.append(" from merchant_draw_coupon where merchant_idx = \(merchantId) order by coupon_idx asc")
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let merchantIdx:Int32 = sqlite3_column_int(stmt, 0)
                let couponIdx:Int32 = sqlite3_column_int(stmt, 1)
                let circleColor:String =  String(cString:sqlite3_column_text(stmt, 2))
                let ringColor:String = String(cString:sqlite3_column_text(stmt, 3))
                let ringThickness:CGFloat = CGFloat(sqlite3_column_double(stmt, 4))
                let isRing:Bool = sqlite3_column_int(stmt, 5) > 0
                let checkLineWidth:CGFloat = CGFloat(sqlite3_column_double(stmt, 6))
                let checkLineColor:String = String(cString:sqlite3_column_text(stmt, 7))
                let isEvent:Bool = sqlite3_column_int(stmt, 7) > 0
                
                var drawCouponModel:DrawCouponModel = DrawCouponModel()
                drawCouponModel.merchantId = Int(merchantIdx)
                drawCouponModel.couponId = Int(couponIdx)
                drawCouponModel.circleColor = circleColor
                drawCouponModel.ringColor = ringColor
                drawCouponModel.ringThickness = ringThickness
                drawCouponModel.isRing = isRing
                drawCouponModel.checkLineColor = checkLineColor
                drawCouponModel.checkLineWidth = checkLineWidth
                drawCouponModel.isEvent = isEvent
                drawCouponList.append(drawCouponModel)
            }
        } else {
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print(errorMessage)
        }
        return drawCouponList
    }
    
    // 가맹점 - 쿠폰 정보 가져오기 ( Image용 )
    func selectImageCouponData(merchantId:Int) throws -> [ImageCouponModel] {
        guard db != nil else { throw SQLError.connectionError }
        defer { sqlite3_finalize(stmt) }
        var imageCouponList:[ImageCouponModel] =  [ImageCouponModel]()
        var query = "select merchant_idx, coupon_idx, normal_image, select_image, is_event"
        query.append(" from merchant_image_coupon where merchant_idx = \(merchantId) order by coupon_idx asc")
        if sqlite3_prepare(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                let merchantIdx:Int32 = sqlite3_column_int(stmt, 0)
                let couponIdx:Int32 = sqlite3_column_int(stmt, 1)
                let normalImage:String = String(cString:sqlite3_column_text(stmt, 2))
                let selectImage:String = String(cString:sqlite3_column_text(stmt, 3))
                let isEvent:Bool = sqlite3_column_int(stmt, 4) > 0
                
                var imageCouponModel:ImageCouponModel = ImageCouponModel()
                imageCouponModel.merchantId = Int(merchantIdx)
                imageCouponModel.normalImage = normalImage
                imageCouponModel.selectImage = selectImage
                imageCouponModel.couponId = Int(couponIdx)
                imageCouponModel.isEvent = isEvent
                imageCouponList.append(imageCouponModel)
            }
        } else {
            let errorMessage = String.init(cString: sqlite3_errmsg(db))
            print(errorMessage)
        }
        return imageCouponList
    }

}
