//
//  UserMerchantModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 12. 6..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import Foundation

/* 회원 가맹점 데이터 */

class UserMerchantModel {
    var couponCount:Int? // 적립된 쿠폰 갯수
    var merchantId:Int? // 가맹점 ID
    init() {
        couponCount = 0
    }
}