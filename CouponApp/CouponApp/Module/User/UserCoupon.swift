//
//  UserMerchantModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 12. 6..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import Foundation

/// 회원 쿠폰 데이터
final class UserCoupon: Codable, MerchantType {

  // MARK: - Define

  private enum UserCouponKeys: String, CodingKey {
    case merchantId = "merchant_id"
    case couponCount = "coupon_count"
  }

  // MARK: - Property

  /// 적립된 쿠폰 갯수
  var couponCount: Int
  /// 가맹점 ID
  var merchantId: Int
  /// 선택된 쿠폰 인덱스
  var isSelectedIndex: Int {
    return self.couponCount - 1
  }

  // MARK: - Init

  init() {
    self.couponCount = 0
    self.merchantId = 0
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: UserCouponKeys.self)
    self.merchantId = try container.decode(Int.self, forKey: .merchantId)
    self.couponCount = try container.decode(Int.self, forKey: .couponCount)
  }

  // MARK: - Method

  func addCouponCount() {
    self.couponCount += 1
  }
  
  func clearCouponCount() {
    self.couponCount = 0
  }
}
