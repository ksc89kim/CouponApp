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
      let isSuccessed = try SQLInterface().insertUser(phoneNumber: phoneNumber, password: password, name: name)
      if isSuccessed {
        complete(.success(.init(data: nil)))
      } else {
        complete(.failure(DefaultError.networkError))
      }
    } catch {
      complete(.failure(error))
    }
  }

  func getUserData(phoneNumber: String, complete: @escaping RepositoryCompletion) {
    do {
      let userId = try SQLInterface().selectUserData(phoneNumber: phoneNumber)
      let user = User(id: userId)
      if user.isVaildID {
        complete(.success(.init(data: user)))
      } else {
        complete(.failure(DefaultError.notVaildUser))
      }
    } catch {
      complete(.failure(error))
    }
  }

  func checkPassword(phoneNumber: String, password: String, complete: @escaping RepositoryCompletion) {
    do {
      let userId = try SQLInterface().selectUserData(phoneNumber: phoneNumber, password: password)
      let user = User(id: userId)
      if user.isVaildID {
        complete(.success(.init(data: user)))
      } else {
        complete(.failure(DefaultError.notVaildUser))
      }
    } catch {
      complete(.failure(error))
    }
  }

  func getMerchantData(complete: @escaping RepositoryCompletion) {
    do {
      guard var merchantList = try SQLInterface().selectMerchantData() else {
        complete(.failure(DefaultError.networkError))
        return
      }

      for i in  0 ..< merchantList.count {
        guard var merchant = merchantList[i] else {
          return
        }
        if merchant.isCouponImage {
          merchant.imageCouponList = try SQLInterface().selectImageCouponData(merchantId: merchant.merchantId)
        } else {
          merchant.drawCouponList = try SQLInterface().selectDrawCouponData(merchantId: merchant.merchantId)
        }
        merchantList[i] = merchant
      }

      complete(.success(.init(data: merchantList)))
    } catch {
      complete(.failure(error))
    }
  }

  func insertUserCoupon(userId: Int, merchantId: Int, complete: @escaping RepositoryCompletion) {
    do {
      let isSuccessed = try SQLInterface().insertCoupon(userId, merchantId)
      if isSuccessed {
        complete(.success(.init(data: nil)))
      } else {
        complete(.failure(DefaultError.insertError))
      }
    } catch {
      complete(.failure(error))
    }
  }

  func checkUserCoupon(userId: Int, merchantId: Int, complete: @escaping RepositoryCompletion) {
    do {
      let isUserCoupon = try SQLInterface().isUserCoupon(userId, merchantId)
      if isUserCoupon {
        complete(.success(.init(data: nil)))
      } else {
        complete(.failure(DefaultError.noCouponError))
      }
    } catch {
      complete(.failure(error))
    }
  }

  func deleteUserCoupon(userId:Int, merchantId:Int, complete: @escaping RepositoryCompletion) {
    do{
      let isSuccessed = try SQLInterface().deleteCounpon(userId, merchantId)
      if isSuccessed {
        complete(.success(.init(data: nil)))
      } else {
        complete(.failure(DefaultError.deleteError))
      }
    } catch {
      complete(.failure(error))
    }
  }
  
  func getUserCouponData(userId: Int, complete: @escaping RepositoryCompletion) {
    do {
      let data = try SQLInterface().selectUserCouponData(userId)
      complete(.success(.init(data: data)))
    } catch {
      complete(.failure(error))
    }
  }

  func updateUesrCoupon(userId: Int, merchantId: Int, couponCount: Int, complete: @escaping RepositoryCompletion) {
    do {
      let isSuccessed = try SQLInterface().updateCouponCount(userId, merchantId, couponCount)
      if isSuccessed {
        complete(.success(.init(data: nil)))
      } else {
        complete(.failure(DefaultError.networkError))
      }
    } catch {
      complete(.failure(error))
    }
  }
}
