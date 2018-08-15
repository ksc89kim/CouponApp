//
//  CouponSqlite.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 6..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

struct CouponSqlite:CouponDataProtocol {
    func signup(phoneNumber:String, password:String, name:String, complete: @escaping CouponBaseCallBack) {
        do {
            try SQLInterface().insertUser(phoneNumber: phoneNumber, password: password, name: name, complete:complete)
        } catch {
            complete(false);
        }
    }
    
    func getUserData(phoneNumber:String, complete: @escaping CouponBaseCallBack) {
        do {
            CouponSignleton.instance.userData =  UserModel()
            CouponSignleton.instance.userData?.id = try SQLInterface().selectUserData(phoneNumber: phoneNumber)
            if CouponSignleton.instance.userData?.id != 0 {
                complete(true)
            } else {
                complete(false)
            }
        } catch {
            complete(false)
        }
    }
    
    func checkPassword(phoneNumber:String, password:String, complete: @escaping CouponBaseCallBack) {
        do {
            CouponSignleton.instance.userData?.id = try SQLInterface().selectUserData(phoneNumber: phoneNumber, password:password)
            if CouponSignleton.instance.userData?.id != nil {
                complete(true)
            } else {
                complete(false)
            }
        } catch {
            complete(false)
        }
    }
    
    func getMerchantData(complete: @escaping CouponBaseCallBack) {
        do {
            guard var merchantList = try SQLInterface().selectMerchantData() else {
                complete(false)
                return
            }
            
            for i in  0 ..< merchantList.count {
                guard var model = merchantList[i] else {
                    return
                }
                if model.isCouponImage {
                    model.imageCouponList = try SQLInterface().selectImageCouponData(merchantId: model.merchantId)
                } else {
                    model.drawCouponList = try SQLInterface().selectDrawCouponData(merchantId: model.merchantId)
                }
                merchantList[i] = model
            }
            CouponSignleton.instance.merchantList = merchantList
            complete(true)
        } catch {
            complete(false)
        }
    }
    
    func insertUserCoupon(userId:Int, merchantId:Int, complete: @escaping CouponBaseCallBack) {
        do {
            try SQLInterface().insertCoupon(userId, merchantId, complete:complete)
        } catch {
            complete(false)
        }
    }
    
    func checkUserCoupon(userId:Int, merchantId:Int, complete: @escaping CouponBaseCallBack) {
        do {
            let isUserCoupon = try SQLInterface().isUserCoupon(userId,merchantId)
            complete(isUserCoupon)
        } catch {
            complete(false)
        }
    }
    
    func deleteUserCoupon(userId:Int, merchantId:Int, complete: @escaping CouponBaseCallBack) {
        do{
            try SQLInterface().deleteCounpon(userId, merchantId, complete:complete)
        } catch {
            complete(false)
        }
    }
    
    func getUserCouponData(userId:Int, complete: @escaping (Bool, UserCouponListModel?) -> Void) {
        do {
            complete(true, try SQLInterface().selectUserCouponData(userId))
        } catch {
            complete(false, nil)
        }
    }
    
    func updateUesrCoupon(userId:Int, merchantId:Int, couponCount:Int, complete: @escaping CouponBaseCallBack) {
        do {
            try SQLInterface().updateCouponCount(userId,merchantId,couponCount,complete:complete)
        } catch {
            complete(false)
        }
    }
    
    
}
