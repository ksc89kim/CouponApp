//
//  CouponData.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 6..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

class CouponData {
    static let isSqlite = true
    // MARK: - 회원가입 하기
    static func signup(phoneNumber:String, password:String, name:String, complete: @escaping CouponBaseCallBack){
        getCouponDataProtocol().signup(phoneNumber: phoneNumber, password: password, name: name, complete: complete)
    }
    
    // MARK: - 회원 정보 가져오기
    static func getUserData(phoneNumber:String, complete: @escaping CouponBaseCallBack) {
       getCouponDataProtocol().getUserData(phoneNumber: phoneNumber, complete: complete)
    }
    
    // MARK: - 패스워드 확인
    static func checkPassword(phoneNumber:String, password:String, complete: @escaping CouponBaseCallBack) {
        getCouponDataProtocol().checkPassword(phoneNumber: phoneNumber, password: password, complete: complete)
    }
    
    // MARK: - 가맹점 데이터 가져오기
    static func getMerchantData(complete: @escaping CouponBaseCallBack) {
       getCouponDataProtocol().getMerchantData(complete: complete)
    }
    
    // MARK: - 유저 쿠폰 추가하기
    static func insertUserCoupon(userId:Int, merchantId:Int, complete: @escaping CouponBaseCallBack) {
       getCouponDataProtocol().insertUserCoupon(userId: userId, merchantId: merchantId, complete: complete)
    }
    
    // MARK: - 유저 쿠폰 확인하기
    static func checkUserCoupon(userId:Int, merchantId:Int, complete: @escaping CouponBaseCallBack){
       getCouponDataProtocol().checkUserCoupon(userId: userId, merchantId: merchantId, complete: complete)
    }
    
    // MARK: - 유저 쿠폰 삭제하기
    static func deleteUserCoupon(userId:Int, merchantId:Int, complete: @escaping CouponBaseCallBack){
        getCouponDataProtocol().deleteUserCoupon(userId: userId, merchantId: merchantId, complete: complete)
    }
    
    // MARK: - 유저 쿠폰 데이터 요청하기
    static func getUserCouponData(userId:Int, complete: @escaping (Bool, UserCouponListModel?) -> Void) {
        getCouponDataProtocol().getUserCouponData(userId: userId, complete: complete)
    }
    
    // MARK: - 유저 쿠폰 카운트 업데이트 하기.
    static func updateUesrCoupon(userId:Int, merchantId:Int, couponCount:Int, complete: @escaping CouponBaseCallBack){
        getCouponDataProtocol().updateUesrCoupon(userId: userId, merchantId: merchantId, couponCount: couponCount, complete: complete)
    }
    
    static func getCouponDataProtocol() -> CouponDataProtocol {
        return (isSqlite) ? CouponSqlite() : CouponNetwork()
    }
    
}