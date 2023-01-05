//
//  RxCouponRepository.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/10/25.
//  Copyright © 2020 kim sunchul. All rights reserved.∫
//

import RxSwift

extension CouponRepository: ReactiveCompatible {
}

extension Reactive where Base: CouponRepository {
  func signup(phoneNumber: String, password: String, name: String) -> Single<Bool> {
    return Single.create { [weak base] single in
      base?.signup(phoneNumber: phoneNumber, password: password, name: name) { isSuccessed in
        single(.success(isSuccessed))
      }
      return Disposables.create()
    }
  }

  func loadUserData(phoneNumber: String) -> Single<Bool> {
    return Single.create { [weak base] single in
      base?.loadUserData(phoneNumber: phoneNumber) { isSuccessed in
        single(.success(isSuccessed))
      }
      return Disposables.create()
    }
  }

  func checkPassword(phoneNumber: String, password: String) -> Single<Bool> {
    return Single.create { [weak base] single in
      base?.checkPassword(phoneNumber: phoneNumber, password: password) { isSuccessed in
        single(.success(isSuccessed))
      }
      return Disposables.create()
    }
  }

  func loadMerchantData() -> Single<Bool> {
    return Single.create { [weak base] single in
      base?.loadMerchantData() { isSuccessed in
        single(.success(isSuccessed))
      }
      return Disposables.create()
    }
  }

  func insertUserCoupon(userId: Int, merchantId: Int) -> Single<Bool> {
    return Single.create { [weak base] single in
      base?.insertUserCoupon(userId: userId, merchantId: merchantId) { isSuccessed in
        single(.success(isSuccessed))
      }
      return Disposables.create()
    }
  }

  func checkUserCoupon(userId: Int, merchantId: Int) -> Single<Bool> {
    return Single.create { [weak base] single in
      base?.checkUserCoupon(userId: userId, merchantId: merchantId) { isSuccessed in
        single(.success(isSuccessed))
      }
      return Disposables.create()
    }
  }

  func deleteUserCoupon(userId: Int, merchantId: Int) -> Single<Bool> {
    return Single.create { [weak base] single in
      base?.deleteUserCoupon(userId: userId, merchantId: merchantId) { isSuccessed in
        single(.success(isSuccessed))
      }
      return Disposables.create()
    }
  }

  func loadUserCouponData(userId: Int) -> Single<(Bool, UserCouponList?)> {
    return Single.create { [weak base] single in
      base?.loadUserCouponData(userId: userId) { isSuccessed, userCouponList in
        single(.success((isSuccessed, userCouponList)))
      }
      return Disposables.create()
    }
  }

  func updateUesrCoupon(userId: Int, merchantId: Int, couponCount: Int) -> Single<Bool> {
    return Single.create { [weak base] single in
      base?.updateUesrCoupon(userId: userId, merchantId: merchantId, couponCount: couponCount) { isSuccessed in
        single(.success(isSuccessed))
      }
      return Disposables.create()
    }
  }
}

