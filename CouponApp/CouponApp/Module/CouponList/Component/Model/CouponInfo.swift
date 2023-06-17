//
//  CouponInfo.swift
//  CouponApp
//
//  Created by kim sunchul on 2022/05/06.
//  Copyright © 2022 kim sunchul. All rights reserved.
//

import Foundation

// MARK: - CouponInfoKey

enum CouponInfoKey: InjectionKey {
  typealias Value = CouponInfoType
}


// MARK: - CouponInfoType

protocol CouponInfoType: Injectable {
  var userCoupon: UserCoupon? { get set }
  var merchant: Merchant? { get set }
  var userCouponCount: Int { get }
  var merchantCouponCount: Int { get }
  var isAvailableAddCoupon: Bool { get }
  var isAvailableUseCoupon: Bool { get }
  
  mutating func setCouponInfo(_ couponInfo: CouponInfoType)
}


// MARK: - CouponInfo

struct CouponInfo: CouponInfoType {

  // MARK: - Property

  var userCoupon: UserCoupon?
  var merchant: Merchant?

  var userCouponCount: Int {
    return self.userCoupon?.couponCount ?? 0
  }

  var merchantCouponCount: Int {
    return self.merchant?.couponCount() ?? 0
  }

  var isAvailableAddCoupon: Bool {
    return self.userCouponCount < self.merchantCouponCount
  }

  var isAvailableUseCoupon: Bool {
    return self.userCouponCount >= self.merchantCouponCount
  }

  // MARK: - Set

  mutating func setCouponInfo(_ couponInfo: CouponInfoType) {
    self.userCoupon = couponInfo.userCoupon
    self.merchant = couponInfo.merchant
  }
}
