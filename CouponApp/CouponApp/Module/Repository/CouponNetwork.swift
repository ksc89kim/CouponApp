//
//  CouponNetwork.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 2. 6..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
import Alamofire

/// 쿠폰 네트워크 관리자
final class CouponNetwork : RepositoryType {

  // MARK: - Property

  var mainUrl = "http://192.168.0.11:8080/CouponProject/"

  // MARK: - Network

  func signup(phoneNumber: String, password: String, name: String, complete: @escaping RepositoryCompletion) {
    let fullUrl = "\(self.mainUrl)user_sign"
    let parameter = [
      "phone_number": phoneNumber,
      "password": password,
      "name": name
    ]

    CouponNetwork.showProgress()
    let request = AF.request(URL(fileURLWithPath: fullUrl), method: .get, parameters: parameter)
    request.responseDecodable(of: ResponseCode.self) { (response: AFDataResponse<ResponseCode>) in
      CouponNetwork.closeProgress()
      complete(.init(isSuccessed: CouponNetwork.checkResponseData(response), data: nil))
    }
  }

  func getUserData(phoneNumber: String, complete: @escaping RepositoryCompletion) {
    let fullUrl = "\(self.mainUrl)user_data"
    let parameter = [
      "phone_number": phoneNumber,
      "mode": "GetUserInfo"
    ]

    CouponNetwork.showProgress()
    let request = AF.request(URL(fileURLWithPath: fullUrl), method: .post, parameters: parameter)
    request.responseDecodable(of: ResponseCode.self) { (response: AFDataResponse<ResponseCode>) in
      CouponNetwork.closeProgress()
      guard CouponNetwork.checkResponseData(response), let responseData = response.data else {
        self.fail(complete: complete)
        return
      }
      do {
        complete(.init(isSuccessed: true, data: try JSONDecoder().decode(User.self, from: responseData)))
      } catch {
        self.fail(complete: complete)
      }
    }
  }

  func checkPassword(phoneNumber: String, password: String, complete: @escaping RepositoryCompletion) {
    let fullUrl = "\(self.mainUrl)user_data"
    let parameter = [
      "phone_number": phoneNumber,
      "password": password,
      "mode": "CheckUserPassword"
    ]

    CouponNetwork.showProgress()
    let request = AF.request(URL(fileURLWithPath: fullUrl), method: .post, parameters: parameter)
    request.responseDecodable(of: ResponseCode.self) {  (response: AFDataResponse<ResponseCode>) in
      CouponNetwork.closeProgress()
      guard CouponNetwork.checkResponseData(response), let responseData = response.data else {
        self.fail(complete: complete)
        return
      }
      do {
        complete(.init(isSuccessed: true, data: try JSONDecoder().decode(User.self, from: responseData)))
      } catch {
        self.fail(complete: complete)
      }
    }
  }

  func getMerchantData(complete: @escaping RepositoryCompletion) {
    let fullUrl = "\(self.mainUrl)merchant_data"
    let parameter = ["mode": "GetMerchantData"]
    CouponNetwork.showProgress()
    let request = AF.request(URL(fileURLWithPath: fullUrl), method: .post, parameters: parameter)
    request.responseDecodable(of: ResponseCode.self) {  (response: AFDataResponse<ResponseCode>) in
      CouponNetwork.closeProgress()
      guard CouponNetwork.checkResponseData(response), let responseData = response.data else {
        self.fail(complete: complete)
        return
      }
      do {
        let merchantList = try JSONDecoder().decode(MerchantImplList.self, from: responseData)
        CouponSignleton.instance.merchantList = merchantList
        complete(.init(isSuccessed: true, data: merchantList))
      } catch {
        print("error \(error)")
        self.fail(complete: complete)
      }
    }
  }

  func insertUserCoupon(userId: Int, merchantId: Int, complete: @escaping RepositoryCompletion) {
    let fullUrl = "\(self.mainUrl)coupon_data"
    let parameter = [
      "mode": "InsertCouponData",
      "user_id": userId,
      "merchant_id": merchantId
    ] as [String : Any]

    CouponNetwork.showProgress()
    let request = AF.request(URL(fileURLWithPath: fullUrl), method: .post, parameters: parameter)
    request.responseDecodable(of: ResponseCode.self) {  (response: AFDataResponse<ResponseCode>) in
      CouponNetwork.closeProgress()
      complete(.init(isSuccessed: CouponNetwork.checkResponseData(response), data: nil))
    }
  }

  func checkUserCoupon(userId: Int, merchantId: Int, complete: @escaping RepositoryCompletion) {
    let fullUrl = "\(self.mainUrl)coupon_data"
    let parameter = [
      "mode": "CheckCouponData",
      "user_id":userId,
      "merchant_id": merchantId
    ] as [String : Any]

    CouponNetwork.showProgress()
    let request = AF.request(URL(fileURLWithPath: fullUrl), method: .post, parameters: parameter)
    request.responseDecodable(of: ResponseCode.self) {  (response: AFDataResponse<ResponseCode>) in
      CouponNetwork.closeProgress()
      guard CouponNetwork.checkResponseData(response), let responseData = response.data else {
        self.fail(complete: complete)
        return
      }

      do {
        let checkCouponData = try JSONDecoder().decode(ExistenceCoupon.self, from: responseData)
        complete(.init(isSuccessed: checkCouponData.isCouponData, data: checkCouponData))
      } catch {
        self.fail(complete: complete)
      }
    }
  }

  func deleteUserCoupon(userId: Int, merchantId: Int, complete: @escaping RepositoryCompletion) {
    let fullUrl = "\(self.mainUrl)coupon_data"
    let parameter = [
      "mode":"DeleteCouponData",
      "user_id":userId,
      "merchant_id":merchantId
    ] as [String : Any]

    CouponNetwork.showProgress()
    let request = AF.request(URL(fileURLWithPath: fullUrl), method: .post, parameters: parameter)
    request.responseDecodable(of: ResponseCode.self) {  (response: AFDataResponse<ResponseCode>) in
      CouponNetwork.closeProgress()
      complete(.init(isSuccessed: CouponNetwork.checkResponseData(response), data: nil))
    }
  }

  func getUserCouponData(userId: Int, complete: @escaping RepositoryCompletion) {
    let fullUrl = "\(self.mainUrl)coupon_data"
    let parameter = [
      "mode": "GetCouponData",
      "user_id": userId
    ] as [String : Any]

    let request = AF.request(URL(fileURLWithPath: fullUrl), method: .post, parameters: parameter)
    request.responseDecodable(of: ResponseCode.self) {  (response: AFDataResponse<ResponseCode>) in
      CouponNetwork.closeProgress()
      guard CouponNetwork.checkResponseData(response), let responseData = response.data else {
        self.fail(complete: complete)
        return
      }

      do {
        let userCouponList = try JSONDecoder().decode(UserCouponList.self, from: responseData)
        complete(.init(isSuccessed: true, data: userCouponList))
      } catch {
        self.fail(complete: complete)
      }
    }
  }

  func updateUesrCoupon(userId: Int, merchantId: Int, couponCount: Int, complete: @escaping RepositoryCompletion) {
    let fullUrl = "\(self.mainUrl)coupon_data"
    let parameter = [
      "mode": "UpdateCouponData",
      "user_id": userId,
      "merchant_id": merchantId,
      "coupon_count": couponCount
    ] as [String : Any]
    
    CouponNetwork.showProgress()
    let request = AF.request(URL(fileURLWithPath: fullUrl), method: .post, parameters: parameter)
    request.responseDecodable(of: ResponseCode.self) {  (response: AFDataResponse<ResponseCode>) in
      CouponNetwork.closeProgress()
      complete(.init(isSuccessed: CouponNetwork.checkResponseData(response), data: nil))
    }
  }

  // MARK: - ETC

  static func checkResponseData(_ response: AFDataResponse<ResponseCode>) -> Bool {
    switch response.result {
    case .success(let respCode):
      return respCode.isSuccess
    case .failure(let error):
      print("error = \(error.localizedDescription)")
      print("response = \(response)")
      return false
    }
  }

  static func showProgress() {
    UIApplication.shared.beginIgnoringInteractionEvents()
  }

  static func closeProgress() {
    UIApplication.shared.endIgnoringInteractionEvents()
  }
}
