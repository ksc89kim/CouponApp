//
//  UserModel.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 2. 8..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

/*
     회원 데이터
 */
class UserModel {
    var name:String?
    var phoneNumber:String?
    var id:Int?
    
    func parseData(data:[String:Any]){
        self.name = data["name"] as? String;
        self.phoneNumber = data["phoneNumber"] as? String;
        self.id = data["userId"] as? Int
    }
}
