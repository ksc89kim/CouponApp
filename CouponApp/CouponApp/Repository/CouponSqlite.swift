//
//  CouponSqlite.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 6..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

struct CouponSqlite: RepositoryType {
  func signup(phoneNumber: String, password: String, name: String, complete: @escaping RepositoryCompletion) {
    do {
      try SQLInterface().insertUser(phoneNumber: phoneNumber, password: password, name: name, complete:complete)
    } catch {
      complete(false);
    }
  }

  func getUserData(phoneNumber: String, complete: @escaping RepositoryCompletion) {
    do {
      let userId = try SQLInterface().selectUserData(phoneNumber: phoneNumber)
      CouponSignleton.instance.userData = User(id:userId)
      complete(CouponSignleton.isExistUseId())
    } catch {
      complete(false)
    }
  }

  func checkPassword(phoneNumber: String, password: String, complete: @escaping RepositoryCompletion) {
    do {
      let userId = try SQLInterface().selectUserData(phoneNumber: phoneNumber, password:password)
      CouponSignleton.instance.userData = User(id:userId)
      complete(CouponSignleton.isExistUseId())
    } catch {
      complete(false)
    }
  }

  func getMerchantData(complete: @escaping RepositoryCompletion) {
    do {
      guard var merchantList = try SQLInterface().selectMerchantData() else {
        complete(false)
        return
      }

      for i in  0 ..< merchantList.count {
        guard let merchant = merchantList[i] else {
          return
        }
        if merchant.isCouponImage {
          merchant.imageCouponList = try SQLInterface().selectImageCouponData(merchantId: merchant.merchantId)
        } else {
          merchant.drawCouponList = try SQLInterface().selectDrawCouponData(merchantId: merchant.merchantId)
        }
        merchantList[i] = merchant
      }
      CouponSignleton.instance.merchantList = merchantList
      complete(true)
    } catch {
      complete(false)
    }
  }

  func insertUserCoupon(userId: Int, merchantId: Int, complete: @escaping RepositoryCompletion) {
    do {
      try SQLInterface().insertCoupon(userId, merchantId, complete:complete)
    } catch {
      complete(false)
    }
  }

  func checkUserCoupon(userId: Int, merchantId: Int, complete: @escaping RepositoryCompletion) {
    do {
      let isUserCoupon = try SQLInterface().isUserCoupon(userId,merchantId)
      complete(isUserCoupon)
    } catch {
      complete(false)
    }
  }

  func deleteUserCoupon(userId:Int, merchantId:Int, complete: @escaping RepositoryCompletion) {
    do{
      try SQLInterface().deleteCounpon(userId, merchantId, complete:complete)
    } catch {
      complete(false)
    }
  }
  
  func getUserCouponData(userId: Int, complete: @escaping (Bool, UserCouponList?) -> Void) {
    do {
      complete(true, try SQLInterface().selectUserCouponData(userId))
    } catch {
      complete(false, nil)
    }
  }

  func updateUesrCoupon(userId: Int, merchantId: Int, couponCount: Int, complete: @escaping RepositoryCompletion) {
    do {
      try SQLInterface().updateCouponCount(userId,merchantId,couponCount,complete:complete)
    } catch {
      complete(false)
    }
  }
}
