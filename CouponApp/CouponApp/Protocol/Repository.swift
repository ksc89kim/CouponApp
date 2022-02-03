//
//  Repository.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 6..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

typealias RepositoryCompletion = (Bool) -> Void

protocol Repository {
  func signup(phoneNumber:String, password:String, name:String, complete: @escaping RepositoryCompletion)
  func getUserData(phoneNumber:String, complete: @escaping RepositoryCompletion)
  func checkPassword(phoneNumber:String, password:String, complete: @escaping RepositoryCompletion)
  func getMerchantData(complete: @escaping RepositoryCompletion)
  func insertUserCoupon(userId:Int, merchantId:Int, complete: @escaping RepositoryCompletion)
  func checkUserCoupon(userId:Int, merchantId:Int, complete: @escaping RepositoryCompletion)
  func deleteUserCoupon(userId:Int, merchantId:Int, complete: @escaping RepositoryCompletion)
  func getUserCouponData(userId:Int, complete: @escaping (Bool, UserCouponList?) -> Void)
  func updateUesrCoupon(userId:Int, merchantId:Int, couponCount:Int, complete: @escaping RepositoryCompletion)
}

