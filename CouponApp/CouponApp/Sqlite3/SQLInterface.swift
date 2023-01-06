//
//  SQLInterface.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 11. 26..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import UIKit
import FMDB

enum SQLError: Error {
  case connectionError
  case queryError
  case otherError
}

final class SQLInterface {

  //MARK: - Property

  lazy var db: FMDatabase? = {
    var _db: FMDatabase? = nil

    let fileMgr = FileManager.default
    let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let docsDir = dirPath[0] as NSString
    let dbPath = docsDir.appendingPathComponent("coupon.db") as NSString

    if !fileMgr.fileExists(atPath: dbPath as String){
      let bundleDbPath = Bundle.main.path(forResource: "coupon", ofType:"db")!
      do {
        try FileManager.default.copyItem(atPath: bundleDbPath, toPath: dbPath as String)
      } catch {
        print("Error : fail copy \(error)")
        return nil;
      }
    }

    _db = FMDatabase(path: dbPath as String)
    if let contactDb = _db, contactDb.open() {
      return _db
    } else {
      print("Error : fail open \(String(describing: _db?.lastErrorMessage()))")
      return nil
    }
  }()

  //MARK: - Init

  init() {
  }

  //MARK: - Deinit

  deinit {
    if let contactDb = db {
      contactDb.close()
    }
  }

  //MARK: - Method

  /// 회원가입
  func insertUser(phoneNumber: String, password: String, name: String, complete: @escaping RepositoryCompletion) throws {
    guard let contactDb = db else { throw SQLError.connectionError }
    let query = "insert into user (phone_number,user_pwd,name) values ('\(phoneNumber)','\(password)','\(name)')"
    let result = contactDb.executeUpdate(query, withArgumentsIn: [])
    if result {
      complete(.init(isSuccessed: true, data: nil))
    } else {
      complete(.init(isSuccessed: false, data: nil))
    }
  }

  /// 회원 데이터 가져 오기
  func selectUserData(phoneNumber: String) throws -> Int {
    guard let contactDb = db else { throw SQLError.connectionError }
    var userId:Int = 0
    let query = "select idx from user where phone_number = '\(phoneNumber)'"
    do {
      let result = try contactDb.executeQuery(query, values: [])
      if result.next() {
        userId = Int(result.int(forColumnIndex: 0))
      }
    } catch {
      print("Sqlite error \(contactDb.lastErrorMessage())")
    }

    return userId
  }

  func selectUserData(phoneNumber: String, password: String) throws -> Int {
    guard let contactDb = db else { throw SQLError.connectionError }
    var userId:Int = -1
    let query = "select idx from user where phone_number = '\(phoneNumber)' and user_pwd = '\(password)'"
    do {
      let result = try contactDb.executeQuery(query, values: [])
      if result.next() {
        userId = Int(result.int(forColumnIndex: 0))
      }
    } catch {
      print("Sqlite error \(contactDb.lastErrorMessage())")
    }
    return userId
  }

  /// 회원 쿠폰 데이터 가져오기
  func selectUserCouponData(_ userId: Int) throws -> UserCouponList?  {
    guard let contactDb = db else { throw SQLError.connectionError }
    let query = "select idx,merchant_idx,coupon_count from coupon where user_idx = \(userId)"
    do {
      let result = try contactDb.executeQuery(query, values: [])
      var userCouponList: UserCouponList? = UserCouponList()
      while result.next() {
        let merchantIdx: Int32 = result.int(forColumnIndex: 1)
        let couponCount: Int32 = result.int(forColumnIndex: 2)
        let userCoupon: UserCoupon = UserCoupon()
        userCoupon.merchantId = Int(merchantIdx)
        userCoupon.couponCount = Int(couponCount)
        userCouponList?.append(userCoupon)
      }
      return userCouponList
    } catch {
      print("Sqlite error \(contactDb.lastErrorMessage())")
      return nil
    }
  }

  /// 회원 쿠폰 횟수 업데이트
  func updateCouponCount(_  userId: Int, _ merchantId: Int, _ couponCount: Int, complete: @escaping RepositoryCompletion) throws {
    guard let contactDb = db else { throw SQLError.connectionError }
    let query = "update coupon set coupon_count = \(couponCount)  where user_idx = \(userId) and merchant_idx = \(merchantId)"
    let result = contactDb.executeUpdate(query, withArgumentsIn: [])
    if result {
      complete(.init(isSuccessed: true, data: nil))
    } else {
      complete(.init(isSuccessed: false, data: nil))
    }
  }

  /// 회원 쿠폰 삭제
  func deleteCounpon(_  userId: Int, _ merchantId: Int, complete: @escaping RepositoryCompletion) throws {
    guard let contactDb = db else { throw SQLError.connectionError }
    let query = "delete from coupon where user_idx = \(userId) and merchant_idx = \(merchantId)"
    let result = contactDb.executeUpdate(query, withArgumentsIn: [])
    if result {
      complete(.init(isSuccessed: true, data: nil))
    } else {
      complete(.init(isSuccessed: false, data: nil))
    }
  }

  /// 회원 쿠폰 등록
  func insertCoupon(_  userId: Int, _ merchantId: Int, complete: @escaping RepositoryCompletion) throws {
    guard let contactDb = db else { throw SQLError.connectionError }
    let query = "insert into coupon (merchant_idx, user_idx, coupon_count) values (\(merchantId),\(userId),0)"
    let result = contactDb.executeUpdate(query, withArgumentsIn: [])

    if result {
      complete(.init(isSuccessed: true, data: nil))
    } else {
      complete(.init(isSuccessed: false, data: nil))
    }
  }

  /// 회원 쿠폰 여부
  func isUserCoupon(_  userId: Int, _ merchantId: Int) throws -> Bool {
    guard let contactDb = db else { throw SQLError.connectionError }
    let query = "select COUNT(idx) from coupon where user_idx = \(userId) and merchant_idx = \(merchantId)"
    do {
      let result = try contactDb.executeQuery(query, values: [])
      var count = 0
      while result.next() {
        count = Int(result.int(forColumnIndex: 0))
      }
      if count > 0 {
        return true
      }
      return false
    } catch {
      return false
    }
  }

  /// 가맹점 데이터 가져오기
  func selectMerchantData() throws -> MerchantList?  {
    guard let contactDb = db else { throw SQLError.connectionError }
    let query = "select idx,name,content, image_url, latitude, longitude, is_couponImage, card_background from merchant"
    do {
      let result = try contactDb.executeQuery(query, values: [])
      var merchatList: MerchantList? = MerchantList()
      while result.next() {
        let merchant: Merchant = Merchant(resultSet: result)
        merchatList?.list.append(merchant)
      }
      return merchatList
    } catch {
      print("Sqlite error \(contactDb.lastErrorMessage())")
      return nil
    }
  }

  /// 가맹점 - 쿠폰 정보 가져오기 ( DRAW용 )
  func selectDrawCouponData(merchantId: Int) throws -> [DrawCoupon] {
    guard let contactDb = db else { throw SQLError.connectionError }
    var drawCouponList: [DrawCoupon] =  [DrawCoupon]()
    var query = "select merchant_idx, coupon_idx, circle_color, ring_color,ring_thickness, is_ring, checkline_width, checkline_color, is_event"
    query.append(" from merchant_draw_coupon where merchant_idx = \(merchantId) order by coupon_idx asc")
    do {
      let result = try contactDb.executeQuery(query, values: [])
      while result.next() {
        let drawCoupon: DrawCoupon = DrawCoupon(resultSet: result)
        drawCouponList.append(drawCoupon)
      }
      return drawCouponList
    } catch {
      print("Sqlite error \(contactDb.lastErrorMessage())")
      return drawCouponList
    }
  }

  /// 가맹점 - 쿠폰 정보 가져오기 ( Image용 )
  func selectImageCouponData(merchantId: Int) throws -> [ImageCoupon] {
    guard let contactDb = db else { throw SQLError.connectionError }
    var imageCouponList: [ImageCoupon] =  [ImageCoupon]()
    var query = "select merchant_idx, coupon_idx, normal_image, select_image, is_event"
    query.append(" from merchant_image_coupon where merchant_idx = \(merchantId) order by coupon_idx asc")
    do {
      let result = try contactDb.executeQuery(query, values: [])
      while result.next() {
        let imageCoupon: ImageCoupon = ImageCoupon(resultSet: result)
        imageCouponList.append(imageCoupon)
      }
      return imageCouponList
    } catch {
      print("Sqlite error \(contactDb.lastErrorMessage())")
      return imageCouponList
    }
  }
}
