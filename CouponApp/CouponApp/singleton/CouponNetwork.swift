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
class CouponNetwork {
    
    // MARK: - 회원가입 하기
    static func requestSignup(phoneNumber:String, password:String, name:String, complete: @escaping (Bool) -> Void){
        let networkData = (CouponSignleton.sharedInstance.networkData)!
        if networkData.isSqlite {
            do {
                try SQLInterface().insertUser(phoneNumber: phoneNumber, password: password, name: name, complete:complete)
            } catch {
                complete(false);
            }
        } else {
            let fullUrl = "\(networkData.mainUrl)user_sign"
            let parameter = ["phone_number":phoneNumber,"password":password,"name":name]
            CouponNetwork.showProgress()
            Alamofire.request(fullUrl, method:.post, parameters: parameter)
                .validate().responseJSON(completionHandler: { (response) -> Void in
                    CouponNetwork.closeProgress()
                    print("response = \(response)")
                    let tupleData = CouponNetwork.checkResponseData(response)
                    if tupleData.isSuccess {
                         complete(true)
                    } else {
                         complete(false)
                    }
            })
        }
    }
    
    // MARK: - 회원 정보 가져오기
    static func requestUserData(phoneNumber:String, complete: @escaping (Bool) -> Void) {
        let networkData = (CouponSignleton.sharedInstance.networkData)!
        if networkData.isSqlite {
            do {
                CouponSignleton.sharedInstance.userData?.id = try SQLInterface().selectUserData(phoneNumber: phoneNumber)
                if CouponSignleton.sharedInstance.userData?.id != nil {
                    complete(true)
                } else {
                    complete(false)
                }
            } catch {
                complete(false)
            }
        } else {
            let fullUrl = "\(networkData.mainUrl)user_data"
            let parameter = ["phone_number":phoneNumber, "mode":"GetUserInfo"]
            CouponNetwork.showProgress()
            Alamofire.request(fullUrl, method:.post, parameters: parameter)
                .validate().responseJSON(completionHandler: { (response) -> Void in
                    CouponNetwork.closeProgress()
                    let tupleData = CouponNetwork.checkResponseData(response)
                    if tupleData.isSuccess {
                        let userInfoArray = tupleData.jsonData!["userInfoArray"] as! [Any]
                        let userData = userInfoArray[0] as! [String:Any]
                        CouponSignleton.sharedInstance.userData?.parseData(data: userData)
                        complete(true)
                    } else {
                        complete(false)
                    }
                })
        }
    }
    
    // MARK: - 패스워드 확인
    static func requestCheckPassword(phoneNumber:String, password:String, complete: @escaping (Bool) -> Void) {
        let networkData = (CouponSignleton.sharedInstance.networkData)!
        if networkData.isSqlite {
            do {
                CouponSignleton.sharedInstance.userData?.id = try SQLInterface().selectUserData(phoneNumber: phoneNumber, password:password)
                if CouponSignleton.sharedInstance.userData?.id != nil {
                    complete(true)
                } else {
                    complete(false)
                }
            } catch {
                complete(false)
            }
        } else {
            let fullUrl = "\(networkData.mainUrl)user_data"
            let parameter = ["phone_number":phoneNumber, "password":password, "mode":"CheckUserPassword"]
            CouponNetwork.showProgress()
            Alamofire.request(fullUrl, method:.post, parameters: parameter)
                .validate().responseJSON(completionHandler: { (response) -> Void in
                    CouponNetwork.closeProgress()
                    let tupleData = CouponNetwork.checkResponseData(response)
                    if tupleData.isSuccess {
                        let userId = tupleData.jsonData!["userId"] as! Int
                        CouponSignleton.sharedInstance.userData?.id = userId
                        complete(true)
                    } else {
                        complete(false)
                    }
                })
            
        }
    }
    
    // MARK: - 가맹점 데이터 가져오기
    static func requestGetMerchantData(complete: @escaping (Bool) -> Void) {
        let networkData = (CouponSignleton.sharedInstance.networkData)!
        if networkData.isSqlite {
            do {
                CouponSignleton.sharedInstance.merchantList = try SQLInterface().selectMerchantData()
                for merchantModel in CouponSignleton.sharedInstance.merchantList! {
                    if (merchantModel?.isCouponImage)! {
                        merchantModel?.imageCouponList = try SQLInterface().selectImageCouponData(merchantId: (merchantModel?.merchantId)!)
                    } else {
                        merchantModel?.drawCouponList = try SQLInterface().selectDrawCouponData(merchantId: (merchantModel?.merchantId)!)
                    }
                }
            } catch {
                complete(false)
            }
        } else {
            let fullUrl = "\(networkData.mainUrl)merchant_data"
            let parameter = ["mode":"GetMerchantData"]
            CouponNetwork.showProgress()
            Alamofire.request(fullUrl, method:.post, parameters: parameter)
                .validate().responseJSON(completionHandler: { (response) -> Void in
                    let tupleData = CouponNetwork.checkResponseData(response)
                    CouponNetwork.closeProgress()
                    if tupleData.isSuccess {
                        CouponSignleton.sharedInstance.merchantList =  [MerchantModel]()
                        let merchatJsonList = tupleData.jsonData!["merchantInfoArray"] as! [[String:Any]]
                        for merchantJsonData in merchatJsonList {
                            let merchantModel = MerchantModel()
                            merchantModel.parseData(data: merchantJsonData)
                            CouponSignleton.sharedInstance.merchantList?.append(merchantModel)
                        }
                        complete(true)
                    } else {
                        complete(false)
                    }
                })
        }
    }
    
    // MARK: - 유저 쿠폰 추가하기
    static func requestInsertUserCoupon(userId:Int, merchantId:Int, complete: @escaping (Bool) -> Void) {
        let networkData = (CouponSignleton.sharedInstance.networkData)!
        if networkData.isSqlite {
            do {
                try SQLInterface().insertCoupon(userId, merchantId, complete:complete)
            } catch {
                complete(false)
            }
        } else {
            let fullUrl = "\(networkData.mainUrl)coupon_data"
            let parameter = ["mode":"InsertCouponData","user_id":userId, "merchant_id":merchantId] as [String : Any]
            CouponNetwork.showProgress()
            Alamofire.request(fullUrl, method:.post, parameters: parameter)
            .validate().responseJSON(completionHandler: { (response) -> Void in
                let tupleData = CouponNetwork.checkResponseData(response)
                CouponNetwork.closeProgress()
                if tupleData.isSuccess {
                    complete(true)
                } else {
                    complete(false)
                }
            })
        }
    }
    
    // MARK: - 유저 쿠폰 확인하기
    static func requestCheckUserCoupon(userId:Int, merchantId:Int, complete: @escaping (Bool) -> Void){
        let networkData = (CouponSignleton.sharedInstance.networkData)!
        if networkData.isSqlite {
            do {
                let isUserCoupon = try SQLInterface().isUserCoupon(userId,merchantId)
                complete(isUserCoupon)
            } catch {
                complete(false)
            }
        } else {
            let fullUrl = "\(networkData.mainUrl)coupon_data"
            print("userId = \(userId)")
            print("merchantId = \(merchantId)")
            let parameter = ["mode":"CheckCouponData","user_id":userId, "merchant_id":merchantId] as [String : Any]
            CouponNetwork.showProgress()
            Alamofire.request(fullUrl, method:.post, parameters: parameter)
                .validate().responseJSON(completionHandler: { (response) -> Void in
                let tupleData = CouponNetwork.checkResponseData(response)
                CouponNetwork.closeProgress()
                if tupleData.isSuccess {
                    let isCouponData = tupleData.jsonData!["isCouponData"] as! Bool
                    complete(isCouponData)
                } else {
                    complete(false)
                }
            })
        }
    }
    
    // MARK: - 유저 쿠폰 삭제하기
    static func requestDeleteUserCoupon(userId:Int, merchantId:Int, complete: @escaping (Bool) -> Void){
        let networkData = (CouponSignleton.sharedInstance.networkData)!
        if networkData.isSqlite {
            do{
                try SQLInterface().deleteCounpon(userId, merchantId, complete:complete)
            } catch {
                complete(false)
            }
        } else {
            let fullUrl = "\(networkData.mainUrl)coupon_data"
            let parameter = ["mode":"DeleteCouponData","user_id":userId, "merchant_id":merchantId] as [String : Any]
            CouponNetwork.showProgress()
            Alamofire.request(fullUrl, method:.post, parameters: parameter)
                .validate().responseJSON(completionHandler: { (response) -> Void in
                    let tupleData = CouponNetwork.checkResponseData(response)
                    CouponNetwork.closeProgress()
                    if tupleData.isSuccess {
                        complete(true)
                    } else {
                        complete(false)
                    }
                })
        }
    }
    
    // MARK: - 유저 쿠폰 데이터 요청하기
    static func requestUserCouponData(userId:Int, complete: @escaping (Bool, [UserCouponModel?]?) -> Void) {
        let networkData = (CouponSignleton.sharedInstance.networkData)!
        if networkData.isSqlite {
            do {
                complete(true, try SQLInterface().selectUserCouponData(userId))
            } catch {
               complete(false, nil)
            }
        } else {
            let fullUrl = "\(networkData.mainUrl)coupon_data"
            let parameter = ["mode":"GetCouponData","user_id":userId] as [String : Any]
            Alamofire.request(fullUrl, method:.post, parameters: parameter)
                .validate().responseJSON(completionHandler: { (response) -> Void in
                    let tupleData = CouponNetwork.checkResponseData(response)
                    if tupleData.isSuccess {
                        var userCouponList:[UserCouponModel?]? =  [UserCouponModel]()
                        let userCouponJsonList = tupleData.jsonData!["couponInfoArray"] as! [[String:Any]]
                        for userCouponJsonData in userCouponJsonList {
                            let userCouponModel = UserCouponModel()
                            userCouponModel.parseData(data: userCouponJsonData)
                            userCouponList?.append(userCouponModel)
                        }
                        complete(true,userCouponList)
                    } else {
                        complete(false,nil)
                    }
                })
            
        }
    }
    
    // MARK: - 유저 쿠폰 카운트 업데이트 하기.
    static func requestUpdateUesrCoupon(userId:Int, merchantId:Int, couponCount:Int, complete: @escaping (Bool) -> Void){
        let networkData = (CouponSignleton.sharedInstance.networkData)!
        if networkData.isSqlite {
            do {
                try SQLInterface().updateCouponCount(userId,merchantId,couponCount,complete:complete)
            } catch {
                complete(false)
            }
        } else {
            let fullUrl = "\(networkData.mainUrl)coupon_data"
            let parameter = ["mode":"UpdateCouponData","user_id":userId, "merchant_id":merchantId, "coupon_count":couponCount] as [String : Any]
            CouponNetwork.showProgress()
            Alamofire.request(fullUrl, method:.post, parameters: parameter)
                .validate().responseJSON(completionHandler: { (response) -> Void in
                    let tupleData = CouponNetwork.checkResponseData(response)
                    CouponNetwork.closeProgress()
                    if tupleData.isSuccess {
                       complete(true)
                    } else {
                        complete(false)
                    }
                })
        }
        
    }
    
    // MARK: - 기타등등
    static func checkResponseData(_ response:DataResponse<Any>) -> (isSuccess:Bool,jsonData:[String:AnyObject]?) {
        var isSuccess:Bool = false
        var jsonData:[String:AnyObject]? = nil
        print("log \(response)")
        switch response.result {
        case .success(let data):
            jsonData = data as? [String:AnyObject]
            isSuccess = jsonData!["isSuccess"] as! Bool
            break
        case .failure(_):
            break
        }
        return (isSuccess:isSuccess, jsonData:jsonData)
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
