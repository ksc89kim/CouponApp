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

struct UserModel:Codable {
    var phoneNumber:String
    var id:Int
    var name:String
    
    init() {
        self.phoneNumber = ""
        self.id = 0
        self.name = ""
    }
    
    private enum UserModelKeys: String, CodingKey {
        case phoneNumber
        case name
        case id = "userId"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserModelKeys.self)
        self.phoneNumber = (try? container.decode(String.self, forKey: .phoneNumber)) ?? ""
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
    }
}
