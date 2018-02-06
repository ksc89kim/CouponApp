//
//  CouponNetwork.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 2. 6..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
import Alamofire

/*
     쿠폰 네트워크 관리자
 */
class CouponNetwork {
    static let sharedInstance = CouponNetwork()
    let isSqlite = false;
    
    func requestSignup(phoneNumber:String, password:String, name:String, complete: (Bool) -> Void){
        if isSqlite {
            do {
                try SQLInterface().insertUser(phoneNumber: phoneNumber, password: password, name: name, complete:complete)
            } catch {
                complete(false);
            }
        } else {
        }
    }
    
}
