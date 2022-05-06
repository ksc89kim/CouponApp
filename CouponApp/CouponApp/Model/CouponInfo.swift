//
//  CouponInfo.swift
//  CouponApp
//
//  Created by kim sunchul on 2022/05/06.
//  Copyright © 2022 kim sunchul. All rights reserved.
//

import Foundation

struct CouponInfo {
  let userCoupon: UserCoupon
  let merchant: MerchantImpl
  let isNetworkSuccess: Bool

  init(userCoupon: UserCoupon, merchant: MerchantImpl) {
    self.userCoupon = userCoupon
    self.merchant = merchant
    self.isNetworkSuccess = false
  }

  init(couponInfo: CouponInfo, isNetworkSuccess: Bool) {
    self.userCoupon = couponInfo.userCoupon
    self.merchant = couponInfo.merchant
    self.isNetworkSuccess = isNetworkSuccess
  }

  func isAvailableAddCoupon() -> Bool {
    return self.userCoupon.couponCount < self.merchant.couponCount()
  }

  func isAvailableUseCoupon() -> Bool {
    return self.userCoupon.couponCount >= self.merchant.couponCount()
  }
}
