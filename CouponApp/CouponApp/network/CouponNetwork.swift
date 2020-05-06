//
//  CouponNetwork.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 2. 6..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

/*
     쿠폰 네트워크 관리자
 */
class CouponNetwork : DataController {
    var mainUrl:String = "http://192.168.0.11:8080/CouponProject/"
    
    func signup(phoneNumber:String, password:String, name:String, complete: @escaping DataCallback) {
        let fullUrl = "\(mainUrl)user_sign"
        let parameter = ["phone_number":phoneNumber,"password":password,"name":name]
        CouponNetwork.showProgress()
        Alamofire.request(fullUrl, method:.post, parameters: parameter)
            .validate().responseJSON(completionHandler: { (response) -> Void in
                CouponNetwork.closeProgress()
                if CouponNetwork.checkResponseData(response) {
                    complete(true)
                } else {
                    complete(false)
                }
            })
    }
    
    func getUserData(phoneNumber:String, complete: @escaping DataCallback) {
        let fullUrl = "\(mainUrl)user_data"
        let parameter = ["phone_number":phoneNumber, "mode":"GetUserInfo"]
        CouponNetwork.showProgress()
        Alamofire.request(fullUrl, method:.post, parameters: parameter)
            .validate().responseJSON(completionHandler: { (response) -> Void in
                CouponNetwork.closeProgress()
                if CouponNetwork.checkResponseData(response) {
                    do {
                        CouponSignleton.instance.userData =  try JSONDecoder().decode(User.self, from: response.data!)
                        complete(true)
                    } catch {
                         complete(false)
                    }
                } else {
                    complete(false)
                }
            })
    }
    
    func checkPassword(phoneNumber:String, password:String, complete: @escaping DataCallback) {
        let fullUrl = "\(mainUrl)user_data"
        let parameter = ["phone_number":phoneNumber, "password":password, "mode":"CheckUserPassword"]
        CouponNetwork.showProgress()
        Alamofire.request(fullUrl, method:.post, parameters: parameter)
            .validate().responseJSON(completionHandler: { (response) -> Void in
                CouponNetwork.closeProgress()
                if CouponNetwork.checkResponseData(response) {
                    do {
                        CouponSignleton.instance.userData =  try JSONDecoder().decode(User.self, from: response.data!)
                        complete(true)
                    } catch {
                        complete(false)
                    }
                } else {
                    complete(false)
                }
            })
    }
    
    func getMerchantData(complete: @escaping DataCallback) {
        let fullUrl = "\(mainUrl)merchant_data"
        let parameter = ["mode":"GetMerchantData"]
        CouponNetwork.showProgress()
        Alamofire.request(fullUrl, method:.get, parameters: parameter)
            .validate().responseJSON(completionHandler: { (response) -> Void in
                CouponNetwork.closeProgress()
                if CouponNetwork.checkResponseData(response) {
                    do {
                        CouponSignleton.instance.merchantList = try JSONDecoder().decode(MerchantImplList.self, from: response.data!)
                        complete(true)
                    } catch {
                        print("error \(error)")
                        complete(false)
                    }
                } else {
                    complete(false)
                }
            })
    }
    
    func insertUserCoupon(userId:Int, merchantId:Int, complete: @escaping DataCallback) {
        let fullUrl = "\(mainUrl)coupon_data"
        let parameter = ["mode":"InsertCouponData","user_id":userId, "merchant_id":merchantId] as [String : Any]
        CouponNetwork.showProgress()
        Alamofire.request(fullUrl, method:.post, parameters: parameter)
            .validate().responseJSON(completionHandler: { (response) -> Void in
                CouponNetwork.closeProgress()
                if CouponNetwork.checkResponseData(response) {
                    complete(true)
                } else {
                    complete(false)
                }
            })
    }
    
    func checkUserCoupon(userId:Int, merchantId:Int, complete: @escaping DataCallback) {
        let fullUrl = "\(mainUrl)coupon_data"
        let parameter = ["mode":"CheckCouponData","user_id":userId, "merchant_id":merchantId] as [String : Any]
        CouponNetwork.showProgress()
        Alamofire.request(fullUrl, method:.post, parameters: parameter)
            .validate().responseJSON(completionHandler: { (response) -> Void in
                CouponNetwork.closeProgress()
                if CouponNetwork.checkResponseData(response) {
                    do {
                        let checkCouponData:ExistenceCoupon = try JSONDecoder().decode(ExistenceCoupon.self, from: response.data!)
                        complete(checkCouponData.isCouponData)
                    } catch {
                        complete(false)
                    }
                } else {
                    complete(false)
                }
            })
    }
    
    func deleteUserCoupon(userId:Int, merchantId:Int, complete: @escaping DataCallback) {
        let fullUrl = "\(mainUrl)coupon_data"
        let parameter = ["mode":"DeleteCouponData","user_id":userId, "merchant_id":merchantId] as [String : Any]
        CouponNetwork.showProgress()
        Alamofire.request(fullUrl, method:.post, parameters: parameter)
            .validate().responseJSON(completionHandler: { (response) -> Void in
                CouponNetwork.closeProgress()
                if CouponNetwork.checkResponseData(response) {
                    complete(true)
                } else {
                    complete(false)
                }
            })
    }
    
    func getUserCouponData(userId:Int, complete: @escaping (Bool, UserCouponList?) -> Void) {
        let fullUrl = "\(mainUrl)coupon_data"
        let parameter = ["mode":"GetCouponData","user_id":userId] as [String : Any]
        Alamofire.request(fullUrl, method:.post, parameters: parameter)
            .validate().responseJSON(completionHandler: { (response) -> Void in
                if CouponNetwork.checkResponseData(response) {
                    do {
                        let userCouponList:UserCouponList = try JSONDecoder().decode(UserCouponList.self, from: response.data!)
                        complete(true,userCouponList)
                    } catch {
                        complete(false,nil)
                    }
                } else {
                    complete(false,nil)
                }
            })
    }
    
    func updateUesrCoupon(userId:Int, merchantId:Int, couponCount:Int, complete: @escaping DataCallback) {
        let fullUrl = "\(mainUrl)coupon_data"
        let parameter = ["mode":"UpdateCouponData","user_id":userId, "merchant_id":merchantId, "coupon_count":couponCount] as [String : Any]
        CouponNetwork.showProgress()
        Alamofire.request(fullUrl, method:.post, parameters: parameter)
            .validate().responseJSON(completionHandler: { (response) -> Void in
                CouponNetwork.closeProgress()
                if CouponNetwork.checkResponseData(response) {
                    complete(true)
                } else {
                    complete(false)
                }
            })
    }
    
    // MARK: - 기타등등
    static func checkResponseData(_ response:DataResponse<Any>) -> Bool {
        switch response.result {
        case .success(_):
            do {
                let respCode:ResponseCode = try JSONDecoder().decode(ResponseCode.self, from: response.data!)
                return respCode.isSuccess
            } catch {
                print("error = \(error.localizedDescription)")
                print("response = \(response)")
                return false
            }
        case .failure(let error):
            print("error = \(error.localizedDescription)")
            print("response = \(response)")
            return false
        }
    }
    
    static func showProgress() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        SVProgressHUD.show()
    }
    
    static func closeProgress() {
        UIApplication.shared.endIgnoringInteractionEvents()
        SVProgressHUD.dismiss()
    }
}
