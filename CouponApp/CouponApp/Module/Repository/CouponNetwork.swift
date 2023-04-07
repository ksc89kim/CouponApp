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
      let isSuccessed = CouponNetwork.checkResponseData(response)
      if isSuccessed {
        complete(.success(.init(data: nil)))
      } else {
        complete(.failure(DefaultError.networkError))
      }
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
        complete(.failure(DefaultError.networkError))
        return
      }

      do {
        let data = try JSONDecoder().decode(User.self, from: responseData)
        complete(.success(.init(data: data)))
      } catch {
        complete(.failure(error))
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
        complete(.failure(DefaultError.networkError))
        return
      }

      do {
        let data = try JSONDecoder().decode(User.self, from: responseData)
        complete(.success(.init(data: data)))
      } catch {
        complete(.failure(error))
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
        complete(.failure(DefaultError.networkError))
        return
      }
      do {
        let merchantList = try JSONDecoder().decode(MerchantList.self, from: responseData)
        complete(.success(.init(data: merchantList)))
      } catch {
        complete(.failure(error))
        print("error \(error)")
      }
    }
  }

  func insertUserCoupon(userID: Int, merchantID: Int, complete: @escaping RepositoryCompletion) {
    let fullUrl = "\(self.mainUrl)coupon_data"
    let parameter = [
      "mode": "InsertCouponData",
      "user_id": userID,
      "merchant_id": merchantID
    ] as [String : Any]

    CouponNetwork.showProgress()
    let request = AF.request(URL(fileURLWithPath: fullUrl), method: .post, parameters: parameter)
    request.responseDecodable(of: ResponseCode.self) {  (response: AFDataResponse<ResponseCode>) in
      CouponNetwork.closeProgress()
      let isSuccessed = CouponNetwork.checkResponseData(response)
      if isSuccessed {
        complete(.success(.init(data: nil)))
      } else {
        complete(.failure(DefaultError.insertError))
      }
    }
  }

  func checkUserCoupon(userID: Int, merchantID: Int, complete: @escaping RepositoryCompletion) {
    let fullUrl = "\(self.mainUrl)coupon_data"
    let parameter = [
      "mode": "CheckCouponData",
      "user_id":userID,
      "merchant_id": merchantID
    ] as [String : Any]

    CouponNetwork.showProgress()
    let request = AF.request(URL(fileURLWithPath: fullUrl), method: .post, parameters: parameter)
    request.responseDecodable(of: ResponseCode.self) {  (response: AFDataResponse<ResponseCode>) in
      CouponNetwork.closeProgress()
      guard CouponNetwork.checkResponseData(response), let responseData = response.data else {
        complete(.failure(DefaultError.networkError))
        return
      }

      do {
        let checkCouponData = try JSONDecoder().decode(ExistenceCoupon.self, from: responseData)
        if checkCouponData.isCouponData {
          complete(.success(.init(data: checkCouponData)))
        } else {
          complete(.failure(DefaultError.noCouponError))
        }
      } catch {
        complete(.failure(error))
      }
    }
  }

  func deleteUserCoupon(userID: Int, merchantID: Int, complete: @escaping RepositoryCompletion) {
    let fullUrl = "\(self.mainUrl)coupon_data"
    let parameter = [
      "mode":"DeleteCouponData",
      "user_id":userID,
      "merchant_id":merchantID
    ] as [String : Any]

    CouponNetwork.showProgress()
    let request = AF.request(URL(fileURLWithPath: fullUrl), method: .post, parameters: parameter)
    request.responseDecodable(of: ResponseCode.self) {  (response: AFDataResponse<ResponseCode>) in
      CouponNetwork.closeProgress()
      let isSuccessed = CouponNetwork.checkResponseData(response)
      if isSuccessed {
        complete(.success(.init(data: nil)))
      } else {
        complete(.failure(DefaultError.deleteError))
      }
    }
  }

  func getUserCouponData(userID: Int, complete: @escaping RepositoryCompletion) {
    let fullUrl = "\(self.mainUrl)coupon_data"
    let parameter = [
      "mode": "GetCouponData",
      "user_id": userID
    ] as [String : Any]

    let request = AF.request(URL(fileURLWithPath: fullUrl), method: .post, parameters: parameter)
    request.responseDecodable(of: ResponseCode.self) {  (response: AFDataResponse<ResponseCode>) in
      CouponNetwork.closeProgress()
      guard CouponNetwork.checkResponseData(response), let responseData = response.data else {
        complete(.failure(DefaultError.networkError))
        return
      }

      do {
        let userCouponList = try JSONDecoder().decode(UserCouponList.self, from: responseData)
        complete(.success(.init(data: userCouponList)))
      } catch {
        complete(.failure(error))
      }
    }
  }

  func updateUesrCoupon(userID: Int, merchantID: Int, couponCount: Int, complete: @escaping RepositoryCompletion) {
    let fullUrl = "\(self.mainUrl)coupon_data"
    let parameter = [
      "mode": "UpdateCouponData",
      "user_id": userID,
      "merchant_id": merchantID,
      "coupon_count": couponCount
    ] as [String : Any]
    
    CouponNetwork.showProgress()
    let request = AF.request(URL(fileURLWithPath: fullUrl), method: .post, parameters: parameter)
    request.responseDecodable(of: ResponseCode.self) {  (response: AFDataResponse<ResponseCode>) in
      CouponNetwork.closeProgress()
      let isSuccessed = CouponNetwork.checkResponseData(response)
      if isSuccessed {
        complete(.success(.init(data: nil)))
      } else {
        complete(.failure(DefaultError.networkError))
      }
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
