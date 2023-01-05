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
      try SQLInterface().insertUser(phoneNumber: phoneNumber, password: password, name: name, complete: complete)
    } catch {
      self.fail(complete: complete)
    }
  }

  func getUserData(phoneNumber: String, complete: @escaping RepositoryCompletion) {
    do {
      let userId = try SQLInterface().selectUserData(phoneNumber: phoneNumber)
      let user = User(id: userId)
      complete(.init(isSuccessed: user.isVaildID, data: user))
    } catch {
      self.fail(complete: complete)
    }
  }

  func checkPassword(phoneNumber: String, password: String, complete: @escaping RepositoryCompletion) {
    do {
      let userId = try SQLInterface().selectUserData(phoneNumber: phoneNumber, password: password)
      let user = User(id: userId)
      complete(.init(isSuccessed: user.isVaildID, data: user))
    } catch {
      self.fail(complete: complete)
    }
  }

  func getMerchantData(complete: @escaping RepositoryCompletion) {
    do {
      guard var merchantList = try SQLInterface().selectMerchantData() else {
        self.fail(complete: complete)
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
      complete(.init(isSuccessed: true, data: merchantList))
    } catch {
      self.fail(complete: complete)
    }
  }

  func insertUserCoupon(userId: Int, merchantId: Int, complete: @escaping RepositoryCompletion) {
    do {
      try SQLInterface().insertCoupon(userId, merchantId, complete: complete)
    } catch {
      self.fail(complete: complete)
    }
  }

  func checkUserCoupon(userId: Int, merchantId: Int, complete: @escaping RepositoryCompletion) {
    do {
      let isUserCoupon = try SQLInterface().isUserCoupon(userId, merchantId)
      complete(.init(isSuccessed: isUserCoupon, data: nil))
    } catch {
      self.fail(complete: complete)
    }
  }

  func deleteUserCoupon(userId:Int, merchantId:Int, complete: @escaping RepositoryCompletion) {
    do{
      try SQLInterface().deleteCounpon(userId, merchantId, complete: complete)
    } catch {
      self.fail(complete: complete)
    }
  }
  
  func getUserCouponData(userId: Int, complete: @escaping RepositoryCompletion) {
    do {
      complete(.init(isSuccessed: true, data: try SQLInterface().selectUserCouponData(userId)))
    } catch {
      self.fail(complete: complete)
    }
  }

  func updateUesrCoupon(userId: Int, merchantId: Int, couponCount: Int, complete: @escaping RepositoryCompletion) {
    do {
      try SQLInterface().updateCouponCount(userId, merchantId, couponCount, complete: complete)
    } catch {
      self.fail(complete: complete)
    }
  }
}
