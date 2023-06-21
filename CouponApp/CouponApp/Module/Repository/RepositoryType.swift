//
//  RepositoryType.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 6..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

typealias RepositoryCompletion = (Result<ResponseType, Error>) -> Void

protocol RepositoryType {
  /// 회원가입 하기
  func signup(phoneNumber: String, password: String, name:String, complete: @escaping RepositoryCompletion)
  /// 회원 정보 가져오기
  func getUserData(phoneNumber: String, complete: @escaping RepositoryCompletion)
  /// 패스워드 확인
  func checkPassword(phoneNumber: String, password: String, complete: @escaping RepositoryCompletion)
  /// 가맹점 데이터 가져오기
  func getMerchantData(complete: @escaping RepositoryCompletion)
  /// 유저 쿠폰 추가하기
  func insertUserCoupon(userID: Int, merchantID: Int, complete: @escaping RepositoryCompletion)
  /// 유저 쿠폰 확인하기
  func checkUserCoupon(userID: Int, merchantID: Int, complete: @escaping RepositoryCompletion)
  /// 유저 쿠폰 삭제하기
  func deleteUserCoupon(userID: Int, merchantID: Int, complete: @escaping RepositoryCompletion)
  /// 유저 쿠폰 데이터 요청하기
  func getUserCouponData(userID: Int, complete: @escaping RepositoryCompletion)
  /// 유저 쿠폰 카운트 업데이트 하기.
  func updateUesrCoupon(userID: Int, merchantID: Int, couponCount: Int, complete: @escaping RepositoryCompletion)
}
