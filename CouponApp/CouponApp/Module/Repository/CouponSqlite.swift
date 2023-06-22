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
        let response: ResponseType = DIContainer.resolve(for: ResponseKey.self)
        complete(.success(response))
      } else {
        complete(.failure(DefaultError.networkError))
      }
    } catch {
      complete(.failure(error))
    }
  }

  func getUserData(phoneNumber: String, complete: @escaping RepositoryCompletion) {
    do {
      let userID = try SQLInterface().selectUserData(phoneNumber: phoneNumber)
      var user: User = DIContainer.resolve(for: UserKey.self)
      user.id = userID
      if user.isVaildID {
        var response: ResponseType = DIContainer.resolve(for: ResponseKey.self)
        response.data = user
        complete(.success(response))
      } else {
        complete(.failure(DefaultError.notVaildUser))
      }
    } catch {
      complete(.failure(error))
    }
  }

  func checkPassword(phoneNumber: String, password: String, complete: @escaping RepositoryCompletion) {
    do {
      let userID = try SQLInterface().selectUserData(phoneNumber: phoneNumber, password: password)
      var user: User = DIContainer.resolve(for: UserKey.self)
      user.id = userID
      if user.isVaildID {
        var response: ResponseType = DIContainer.resolve(for: ResponseKey.self)
        response.data = user
        complete(.success(response))
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
          merchant.imageCouponList = try SQLInterface().selectImageCouponData(merchantID: merchant.merchantID)
        } else {
          merchant.drawCouponList = try SQLInterface().selectDrawCouponData(merchantID: merchant.merchantID)
        }
        merchantList[i] = merchant
      }
      if let merchantList = merchantList as? Codable {
        var response: ResponseType = DIContainer.resolve(for: ResponseKey.self)
        response.data = merchantList
        complete(.success(response))
      } else {
        complete(.failure(DefaultError.networkError))
      }
    } catch {
      complete(.failure(error))
    }
  }

  func insertUserCoupon(userID: Int, merchantID: Int, complete: @escaping RepositoryCompletion) {
    do {
      let isSuccessed = try SQLInterface().insertCoupon(userID, merchantID)
      if isSuccessed {
        let response: ResponseType = DIContainer.resolve(for: ResponseKey.self)
        complete(.success(response))
      } else {
        complete(.failure(DefaultError.insertError))
      }
    } catch {
      complete(.failure(error))
    }
  }

  func checkUserCoupon(userID: Int, merchantID: Int, complete: @escaping RepositoryCompletion) {
    do {
      let isUserCoupon = try SQLInterface().isUserCoupon(userID, merchantID)
      if isUserCoupon {
        let response: ResponseType = DIContainer.resolve(for: ResponseKey.self)
        complete(.success(response))
      } else {
        complete(.failure(DefaultError.noCouponError))
      }
    } catch {
      complete(.failure(error))
    }
  }

  func deleteUserCoupon(userID:Int, merchantID:Int, complete: @escaping RepositoryCompletion) {
    do{
      let isSuccessed = try SQLInterface().deleteCounpon(userID, merchantID)
      if isSuccessed {
        let response: ResponseType = DIContainer.resolve(for: ResponseKey.self)
        complete(.success(response))
      } else {
        complete(.failure(DefaultError.deleteError))
      }
    } catch {
      complete(.failure(error))
    }
  }
  
  func getUserCouponData(userID: Int, complete: @escaping RepositoryCompletion) {
    do {
      let data = try SQLInterface().selectUserCouponData(userID)
      var response: ResponseType = DIContainer.resolve(for: ResponseKey.self)
      response.data = data as? any Codable
      complete(.success(response))
    } catch {
      complete(.failure(error))
    }
  }

  func updateUesrCoupon(userID: Int, merchantID: Int, couponCount: Int, complete: @escaping RepositoryCompletion) {
    do {
      let isSuccessed = try SQLInterface().updateCouponCount(userID, merchantID, couponCount)
      if isSuccessed {
        let response: ResponseType = DIContainer.resolve(for: ResponseKey.self)
        complete(.success(response))
      } else {
        complete(.failure(DefaultError.networkError))
      }
    } catch {
      complete(.failure(error))
    }
  }
}
