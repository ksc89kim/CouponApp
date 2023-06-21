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
  func signup(phoneNumber: String, password: String, name: String) -> Single<ResponseType> {
    return Single.create { [weak base] single in
      base?.signup(phoneNumber: phoneNumber, password: password, name: name) { (result: Result<ResponseType, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }

  func loadUserData(phoneNumber: String) -> Single<ResponseType> {
    return Single.create { [weak base] single in
      base?.loadUserData(phoneNumber: phoneNumber) { (result: Result<ResponseType, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }

  func checkPassword(phoneNumber: String, password: String) -> Single<ResponseType> {
    return Single.create { [weak base] single in
      base?.checkPassword(phoneNumber: phoneNumber, password: password) { (result: Result<ResponseType, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }

  func loadMerchantData() -> Single<ResponseType> {
    return Single.create { [weak base] single in
      base?.loadMerchantData() { (result: Result<ResponseType, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }

  func insertUserCoupon(userID: Int, merchantID: Int) -> Single<ResponseType> {
    return Single.create { [weak base] single in
      base?.insertUserCoupon(userID: userID, merchantID: merchantID) { (result: Result<ResponseType, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }

  func checkUserCoupon(userID: Int, merchantID: Int) -> Single<ResponseType> {
    return Single.create { [weak base] single in
      base?.checkUserCoupon(userID: userID, merchantID: merchantID) { (result: Result<ResponseType, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }

  func deleteUserCoupon(userID: Int, merchantID: Int) -> Single<ResponseType> {
    return Single.create { [weak base] single in
      base?.deleteUserCoupon(userID: userID, merchantID: merchantID) { (result: Result<ResponseType, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }

  func loadUserCouponData(userID: Int) -> Single<ResponseType> {
    return Single.create { [weak base] single in
      base?.loadUserCouponData(userID: userID) { (result: Result<ResponseType, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }

  func updateUesrCoupon(userID: Int, merchantID: Int, couponCount: Int) -> Single<ResponseType> {
    return Single.create { [weak base] single in
      base?.updateUesrCoupon(userID: userID, merchantID: merchantID, couponCount: couponCount) { (result: Result<ResponseType, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }
}

