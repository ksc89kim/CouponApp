//
//  UserMerchantModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 12. 6..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import Foundation

/*
     회원 쿠폰 데이터
 */

class UserCoupon:Codable, Merchant {
    var couponCount:Int // 적립된 쿠폰 갯수
    var merchantId:Int // 가맹점 ID
    
    init() {
        couponCount = 0
        merchantId = 0
    }
    
    private enum UserCouponKeys: String, CodingKey {
       case merchantId = "merchant_id"
       case couponCount = "coupon_count"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserCouponKeys.self)
        self.merchantId = try container.decode(Int.self, forKey: .merchantId)
        self.couponCount = try container.decode(Int.self, forKey: .couponCount)
    }
}
