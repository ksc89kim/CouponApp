//
//  CouponRepository.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 6..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

final class CouponRepository {

  // MARK: - Property

  static let instance: CouponRepository = .init(isSqlite: true)
  private let isSqlite: Bool
  private var repository: RepositoryType {
    return self.isSqlite ? CouponSqlite() : CouponNetwork()
  }

  // MARK: - Init

  init(isSqlite: Bool) {
    self.isSqlite = isSqlite
  }

  // MARK: - Method

  func signup(phoneNumber: String, password: String, name: String, complete: @escaping RepositoryCompletion){
    self.repository.signup(phoneNumber: phoneNumber, password: password, name: name, complete: complete)
  }

  func loadUserData(phoneNumber: String, complete: @escaping RepositoryCompletion) {
    self.repository.getUserData(phoneNumber: phoneNumber, complete: complete)
  }

  func checkPassword(phoneNumber: String, password: String, complete: @escaping RepositoryCompletion) {
    self.repository.checkPassword(phoneNumber: phoneNumber, password: password, complete: complete)
  }

  func loadMerchantData(complete: @escaping RepositoryCompletion) {
    self.repository.getMerchantData(complete: complete)
  }

  func insertUserCoupon(userId: Int, merchantId: Int, complete: @escaping RepositoryCompletion) {
    self.repository.insertUserCoupon(userId: userId, merchantId: merchantId, complete: complete)
  }

  func checkUserCoupon(userId:Int, merchantId:Int, complete: @escaping RepositoryCompletion){
    self.repository.checkUserCoupon(userId: userId, merchantId: merchantId, complete: complete)
  }

  func deleteUserCoupon(userId: Int, merchantId: Int, complete: @escaping RepositoryCompletion){
    self.repository.deleteUserCoupon(userId: userId, merchantId: merchantId, complete: complete)
  }

  func loadUserCouponData(userId: Int, complete: @escaping (Bool, UserCouponList?) -> Void) {
    self.repository.getUserCouponData(userId: userId, complete: complete)
  }

  func updateUesrCoupon(userId: Int, merchantId: Int, couponCount: Int, complete: @escaping RepositoryCompletion){
    self.repository.updateUesrCoupon(userId: userId, merchantId: merchantId, couponCount: couponCount, complete: complete)
  }
}
