//
//  RxCouponData.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/10/25.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import RxSwift

final class RxCouponData {

  /// 회원가입 하기
  static func signup(phoneNumber:String, password:String, name:String) -> Single<Bool> {
    return Single.create { single in
      CouponData.signup(phoneNumber: phoneNumber, password: password, name: name) { isSuccessed in
        single(.success(isSuccessed))
      }
      return Disposables.create()
    }
  }

  /// 회원 정보 가져오기
  static func loadUserData(phoneNumber:String) -> Single<Bool> {
    return Single.create { single in
      CouponData.loadUserData(phoneNumber: phoneNumber) { isSuccessed in
        single(.success(isSuccessed))
      }
      return Disposables.create()
    }
  }

  /// 패스워드 확인
  static func checkPassword(phoneNumber:String, password:String) -> Single<Bool> {
    return Single.create { single in
      CouponData.checkPassword(phoneNumber: phoneNumber, password: password) { isSuccessed in
        single(.success(isSuccessed))
      }
      return Disposables.create()
    }
  }

  /// 가맹점 데이터 가져오기
  static func loadMerchantData() -> Single<Bool> {
    return Single.create { single in
      CouponData.loadMerchantData() { isSuccessed in
        single(.success(isSuccessed))
      }
      return Disposables.create()
    }
  }

  /// 유저 쿠폰 추가하기
  static func insertUserCoupon(userId:Int, merchantId:Int) -> Single<Bool> {
    return Single.create { single in
      CouponData.insertUserCoupon(userId: userId, merchantId: merchantId) { isSuccessed in
        single(.success(isSuccessed))
      }
      return Disposables.create()
    }
  }

  /// 유저 쿠폰 확인하기
  static func checkUserCoupon(userId:Int, merchantId:Int) -> Single<Bool> {
    return Single.create { single in
      CouponData.checkUserCoupon(userId: userId, merchantId: merchantId) { isSuccessed in
        single(.success(isSuccessed))
      }
      return Disposables.create()
    }
  }

  /// 유저 쿠폰 삭제하기
  static func deleteUserCoupon(userId:Int, merchantId:Int) -> Single<Bool> {
    return Single.create { single in
      CouponData.deleteUserCoupon(userId: userId, merchantId: merchantId) { isSuccessed in
        single(.success(isSuccessed))
      }
      return Disposables.create()
    }
  }

  /// 유저 쿠폰 데이터 요청하기
  static func loadUserCouponData(userId:Int) -> Single<(Bool, UserCouponList?)> {
    return Single.create { single in
      CouponData.loadUserCouponData(userId: userId) { isSuccessed, userCouponList in
        single(.success((isSuccessed, userCouponList)))
      }
      return Disposables.create()
    }
  }

  /// 유저 쿠폰 카운트 업데이트 하기.
  static func updateUesrCoupon(userId:Int, merchantId:Int, couponCount:Int) -> Single<Bool> {
    return Single.create { single in
      CouponData.updateUesrCoupon(userId: userId, merchantId: merchantId, couponCount: couponCount) { isSuccessed in
        single(.success(isSuccessed))
      }
      return Disposables.create()
    }
  }
}

