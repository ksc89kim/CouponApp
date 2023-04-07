//
//  CouponInfo.swift
//  CouponApp
//
//  Created by kim sunchul on 2022/05/06.
//  Copyright © 2022 kim sunchul. All rights reserved.
//

import Foundation

struct CouponInfo {

  // MARK: - Property

  let userCoupon: UserCoupon
  let merchant: Merchant
  var isAvailableAddCoupon: Bool {
    return self.userCoupon.couponCount < self.merchant.couponCount()
  }
  var isAvailableUseCoupon: Bool {
    return self.userCoupon.couponCount >= self.merchant.couponCount()
  }

  // MARK: - Init

  init(userCoupon: UserCoupon, merchant: Merchant) {
    self.userCoupon = userCoupon
    self.merchant = merchant
  }

  init(couponInfo: CouponInfo) {
    self.userCoupon = couponInfo.userCoupon
    self.merchant = couponInfo.merchant
  }
}
