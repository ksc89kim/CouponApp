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
      base?.signup(phoneNumber: phoneNumber, password: password, name: name) { (result: Result<RepositoryResponse, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }

  func loadUserData(phoneNumber: String) -> Single<RepositoryResponse> {
    return Single.create { [weak base] single in
      base?.loadUserData(phoneNumber: phoneNumber) { (result: Result<RepositoryResponse, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }

  func checkPassword(phoneNumber: String, password: String) -> Single<RepositoryResponse> {
    return Single.create { [weak base] single in
      base?.checkPassword(phoneNumber: phoneNumber, password: password) { (result: Result<RepositoryResponse, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }

  func loadMerchantData() -> Single<RepositoryResponse> {
    return Single.create { [weak base] single in
      base?.loadMerchantData() { (result: Result<RepositoryResponse, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }

  func insertUserCoupon(userID: Int, merchantID: Int) -> Single<RepositoryResponse> {
    return Single.create { [weak base] single in
      base?.insertUserCoupon(userID: userID, merchantID: merchantID) { (result: Result<RepositoryResponse, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }

  func checkUserCoupon(userID: Int, merchantID: Int) -> Single<RepositoryResponse> {
    return Single.create { [weak base] single in
      base?.checkUserCoupon(userID: userID, merchantID: merchantID) { (result: Result<RepositoryResponse, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }

  func deleteUserCoupon(userID: Int, merchantID: Int) -> Single<RepositoryResponse> {
    return Single.create { [weak base] single in
      base?.deleteUserCoupon(userID: userID, merchantID: merchantID) { (result: Result<RepositoryResponse, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }

  func loadUserCouponData(userID: Int) -> Single<RepositoryResponse> {
    return Single.create { [weak base] single in
      base?.loadUserCouponData(userID: userID) { (result: Result<RepositoryResponse, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }

  func updateUesrCoupon(userID: Int, merchantID: Int, couponCount: Int) -> Single<RepositoryResponse> {
    return Single.create { [weak base] single in
      base?.updateUesrCoupon(userID: userID, merchantID: merchantID, couponCount: couponCount) { (result: Result<RepositoryResponse, Error>) in
        single(result)
      }
      return Disposables.create()
    }
  }
}

