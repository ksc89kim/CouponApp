//
//  UserCoupon.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 12. 6..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import Foundation

enum UserCouponKey: InjectionKey {
  typealias Value = UserCouponType
}


protocol UserCouponType: Injectable {
  /// 적립된 쿠폰 갯수
  var couponCount: Int { get set }
  /// 가맹점 ID
  var merchantID: Int { get set }
  /// 선택된 쿠폰 인덱스
  var isSelectedIndex: Int { get }
  /// 쿠폰 갯수 추가
  func addCouponCount()
  /// 쿠폰 갯수 정리
  func clearCouponCount()
}


/// 회원 쿠폰 데이터
final class UserCoupon: Codable, UserCouponType {

  // MARK: - Define

  private enum Keys: String, CodingKey {
    case merchantID = "merchant_id"
    case couponCount = "coupon_count"
  }

  // MARK: - Property

  var couponCount: Int
  var merchantID: Int
  var isSelectedIndex: Int {
    return self.couponCount - 1
  }

  // MARK: - Init

  init() {
    self.couponCount = 0
    self.merchantID = 0
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Keys.self)
    self.merchantID = try container.decode(Int.self, forKey: .merchantID)
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
