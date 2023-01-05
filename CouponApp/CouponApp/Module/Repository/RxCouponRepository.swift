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
  func signup(phoneNumber: String, password: String, name: String) -> Single<RepositoryResponse> {
    return Single.create { [weak base] single in
      base?.signup(phoneNumber: phoneNumber, password: password, name: name) { (response: RepositoryResponse) in
        single(.success(response))
      }
      return Disposables.create()
    }
  }

  func loadUserData(phoneNumber: String) -> Single<RepositoryResponse> {
    return Single.create { [weak base] single in
      base?.loadUserData(phoneNumber: phoneNumber) { (response: RepositoryResponse) in
        single(.success(response))
      }
      return Disposables.create()
    }
  }

  func checkPassword(phoneNumber: String, password: String) -> Single<RepositoryResponse> {
    return Single.create { [weak base] single in
      base?.checkPassword(phoneNumber: phoneNumber, password: password) { (response: RepositoryResponse) in
        single(.success(response))
      }
      return Disposables.create()
    }
  }

  func loadMerchantData() -> Single<RepositoryResponse> {
    return Single.create { [weak base] single in
      base?.loadMerchantData() { (response: RepositoryResponse) in
        single(.success(response))
      }
      return Disposables.create()
    }
  }

  func insertUserCoupon(userId: Int, merchantId: Int) -> Single<RepositoryResponse> {
    return Single.create { [weak base] single in
      base?.insertUserCoupon(userId: userId, merchantId: merchantId) { (response: RepositoryResponse) in
        single(.success(response))
      }
      return Disposables.create()
    }
  }

  func checkUserCoupon(userId: Int, merchantId: Int) -> Single<RepositoryResponse> {
    return Single.create { [weak base] single in
      base?.checkUserCoupon(userId: userId, merchantId: merchantId) { (response: RepositoryResponse) in
        single(.success(response))
      }
      return Disposables.create()
    }
  }

  func deleteUserCoupon(userId: Int, merchantId: Int) -> Single<RepositoryResponse> {
    return Single.create { [weak base] single in
      base?.deleteUserCoupon(userId: userId, merchantId: merchantId) { (response: RepositoryResponse) in
        single(.success(response))
      }
      return Disposables.create()
    }
  }

  func loadUserCouponData(userId: Int) -> Single<RepositoryResponse> {
    return Single.create { [weak base] single in
      base?.loadUserCouponData(userId: userId) { (response: RepositoryResponse) in
        single(.success(response))
      }
      return Disposables.create()
    }
  }

  func updateUesrCoupon(userId: Int, merchantId: Int, couponCount: Int) -> Single<RepositoryResponse> {
    return Single.create { [weak base] single in
      base?.updateUesrCoupon(userId: userId, merchantId: merchantId, couponCount: couponCount) { (response: RepositoryResponse) in
        single(.success(response))
      }
      return Disposables.create()
    }
  }
}

