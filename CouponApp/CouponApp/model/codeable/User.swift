//
//  UserModel.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 2. 8..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

/// 회원 데이터
final class User:Codable {
  let phoneNumber:String
  let id:Int
  let name:String

  init(phoneNumber:String, id:Int, name:String) {
    self.phoneNumber = phoneNumber
    self.id = id
    self.name = name
  }

  convenience init(id:Int) {
    self.init(phoneNumber:"",id: id,name:"")
  }

  private enum UserKeys: String, CodingKey {
    case phoneNumber
    case name
    case id = "userId"
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: UserKeys.self)
    self.phoneNumber = (try? container.decode(String.self, forKey: .phoneNumber)) ?? ""
    self.id = try container.decode(Int.self, forKey: .id)
    self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
  }
}
