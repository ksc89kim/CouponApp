//
//  UserMerchantModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 12. 6..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import Foundation

/// 회원 쿠폰 데이터
final class UserCoupon: Codable, Merchant {
  /// 적립된 쿠폰 갯수
  var couponCount: Int
  /// 가맹점 ID
  var merchantId: Int
  
  init() {
    self.couponCount = 0
    self.merchantId = 0
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
  
  func addCouponCount() {
    self.couponCount += 1
  }
  
  func clearCouponCount() {
    self.couponCount = 0
  }
}
