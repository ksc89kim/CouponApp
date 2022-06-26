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
      complete(CouponNetwork.checkResponseData(response))
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
      guard CouponNetwork.checkResponseData(response) else {
        complete(false)
        return
      }
      do {
        CouponSignleton.instance.userData =  try JSONDecoder().decode(User.self, from: response.data!)
        complete(true)
      } catch {
        complete(false)
      }
    }
  }

  func checkPassword(phoneNumber: String, password: String, complete: @escaping RepositoryCompletion) {
    let fullUrl = "\(self.mainUrl)user_data"
    let parameter = [
      "phone_number":phoneNumber,
      "password":password,
      "mode":"CheckUserPassword"
    ]

    CouponNetwork.showProgress()
    let request = AF.request(URL(fileURLWithPath: fullUrl), method: .post, parameters: parameter)
    request.responseDecodable(of: ResponseCode.self) {  (response: AFDataResponse<ResponseCode>) in
      CouponNetwork.closeProgress()
      guard CouponNetwork.checkResponseData(response) else {
        complete(false)
        return
      }
      do {
        CouponSignleton.instance.userData =  try JSONDecoder().decode(User.self, from: response.data!)
        complete(true)
      } catch {
        complete(false)
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
      guard CouponNetwork.checkResponseData(response) else {
        complete(false)
        return
      }
      do {
        CouponSignleton.instance.merchantList = try JSONDecoder().decode(MerchantImplList.self, from: response.data!)
        complete(true)
      } catch {
        print("error \(error)")
        complete(false)
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
      complete(CouponNetwork.checkResponseData(response))
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
      guard CouponNetwork.checkResponseData(response) else {
        complete(false)
        return
      }

      do {
        let checkCouponData = try JSONDecoder().decode(ExistenceCoupon.self, from: response.data!)
        complete(checkCouponData.isCouponData)
      } catch {
        complete(false)
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
      complete(CouponNetwork.checkResponseData(response))
    }
  }

  func getUserCouponData(userId: Int, complete: @escaping (Bool, UserCouponList?) -> Void) {
    let fullUrl = "\(self.mainUrl)coupon_data"
    let parameter = [
      "mode": "GetCouponData",
      "user_id": userId
    ] as [String : Any]

    let request = AF.request(URL(fileURLWithPath: fullUrl), method: .post, parameters: parameter)
    request.responseDecodable(of: ResponseCode.self) {  (response: AFDataResponse<ResponseCode>) in
      CouponNetwork.closeProgress()
      guard CouponNetwork.checkResponseData(response) else {
        complete(false, nil)
        return
      }

      do {
        let userCouponList = try JSONDecoder().decode(UserCouponList.self, from: response.data!)
        complete(true, userCouponList)
      } catch {
        complete(false,nil)
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
      complete(CouponNetwork.checkResponseData(response))
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
