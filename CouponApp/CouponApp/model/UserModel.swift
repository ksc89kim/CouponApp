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
class UserModel:ParseProtocol {
    var name:String? //회원 이름
    var phoneNumber:String? //회원 전화번호
    var id:Int? //회원 아이디
    
    func parseData(data:[String:Any]){
        self.name = data["name"] as? String;
        self.phoneNumber = data["phoneNumber"] as? String;
        self.id = data["userId"] as? Int
    }
}
