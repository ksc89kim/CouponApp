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
    static let sharedInstance = CouponNetwork()
    let isSqlite = false;
    let mainUrl = "http://192.168.2.28:8080/CouponProject/"
    
    func requestSignup(phoneNumber:String, password:String, name:String, complete: @escaping (Bool) -> Void){
        if isSqlite {
            do {
                try SQLInterface().insertUser(phoneNumber: phoneNumber, password: password, name: name, complete:complete)
            } catch {
                complete(false);
            }
        } else {
            let fullUrl = "\(mainUrl)user_sign"
            let parameter = ["phone_number":phoneNumber,"password":password,"name":name]
            self.showProgress()
            Alamofire.request(fullUrl, method:.post, parameters: parameter)
                .validate().responseJSON(completionHandler: { (response) -> Void in
                    self.closeProgress()
                    print("response = \(response)")
                    let tupleData = self.checkResponseData(response)
                    if tupleData.isSuccess {
                         complete(true)
                    } else {
                         complete(false)
                    }
            })
        }
    }
    
    func requestUserData(phoneNumber:String, complete: @escaping (Bool) -> Void) {
        if isSqlite {
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
            let fullUrl = "\(mainUrl)user_data"
            let parameter = ["phone_number":phoneNumber, "mode":"GetUserInfo"]
            self.showProgress()
            Alamofire.request(fullUrl, method:.post, parameters: parameter)
                .validate().responseJSON(completionHandler: { (response) -> Void in
                    print("response = \(response)")
                    self.closeProgress()
                    
                    let tupleData = self.checkResponseData(response)
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
    
    func checkResponseData(_ response:DataResponse<Any>) -> (isSuccess:Bool,jsonData:[String:AnyObject]?) {
        var isSuccess:Bool = false
        var jsonData:[String:AnyObject]? = nil
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
    
    func showProgress() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        SVProgressHUD.show()
    }
    
    func closeProgress() {
        UIApplication.shared.endIgnoringInteractionEvents()
        SVProgressHUD.dismiss()
    }
}
