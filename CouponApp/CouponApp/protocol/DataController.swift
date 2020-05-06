//
//  CouponDataProtocol.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 6..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

typealias DataCallback = (Bool) -> Void

protocol DataController {
    func signup(phoneNumber:String, password:String, name:String, complete: @escaping DataCallback)
    func getUserData(phoneNumber:String, complete: @escaping DataCallback)
    func checkPassword(phoneNumber:String, password:String, complete: @escaping DataCallback)
    func getMerchantData(complete: @escaping DataCallback)
    func insertUserCoupon(userId:Int, merchantId:Int, complete: @escaping DataCallback)
    func checkUserCoupon(userId:Int, merchantId:Int, complete: @escaping DataCallback)
    func deleteUserCoupon(userId:Int, merchantId:Int, complete: @escaping DataCallback)
    func getUserCouponData(userId:Int, complete: @escaping (Bool, UserCouponList?) -> Void)
    func updateUesrCoupon(userId:Int, merchantId:Int, couponCount:Int, complete: @escaping DataCallback)
}

