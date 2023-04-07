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

  func insertUserCoupon(userID: Int, merchantID: Int, complete: @escaping RepositoryCompletion) {
    self.repository.insertUserCoupon(userID: userID, merchantID: merchantID, complete: complete)
  }

  func checkUserCoupon(userID:Int, merchantID:Int, complete: @escaping RepositoryCompletion){
    self.repository.checkUserCoupon(userID: userID, merchantID: merchantID, complete: complete)
  }

  func deleteUserCoupon(userID: Int, merchantID: Int, complete: @escaping RepositoryCompletion){
    self.repository.deleteUserCoupon(userID: userID, merchantID: merchantID, complete: complete)
  }

  func loadUserCouponData(userID: Int, complete: @escaping RepositoryCompletion) {
    self.repository.getUserCouponData(userID: userID, complete: complete)
  }

  func updateUesrCoupon(userID: Int, merchantID: Int, couponCount: Int, complete: @escaping RepositoryCompletion){
    self.repository.updateUesrCoupon(userID: userID, merchantID: merchantID, couponCount: couponCount, complete: complete)
  }
}
