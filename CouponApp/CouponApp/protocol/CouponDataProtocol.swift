//
//  CouponDataProtocol.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 6..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

typealias CouponBaseCallBack = (Bool) -> Void

protocol CouponDataProtocol {
    func signup(phoneNumber:String, password:String, name:String, complete: @escaping CouponBaseCallBack)
    func getUserData(phoneNumber:String, complete: @escaping CouponBaseCallBack)
    func checkPassword(phoneNumber:String, password:String, complete: @escaping CouponBaseCallBack) 
    func getMerchantData(complete: @escaping CouponBaseCallBack)
    func insertUserCoupon(userId:Int, merchantId:Int, complete: @escaping CouponBaseCallBack)
    func checkUserCoupon(userId:Int, merchantId:Int, complete: @escaping CouponBaseCallBack)
    func deleteUserCoupon(userId:Int, merchantId:Int, complete: @escaping CouponBaseCallBack)
    func getUserCouponData(userId:Int, complete: @escaping (Bool, UserCouponListModel?) -> Void)
    func updateUesrCoupon(userId:Int, merchantId:Int, couponCount:Int, complete: @escaping CouponBaseCallBack)
}

