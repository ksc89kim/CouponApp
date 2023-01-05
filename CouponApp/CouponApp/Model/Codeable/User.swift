//
//  UserModel.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 2. 8..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

/// 회원 데이터
final class User: Codable {

  // MARK: - Define

  private enum UserKeys: String, CodingKey {
    case phoneNumber
    case name
    case id = "userId"
  }

  // MARK: - Property

  /// 전화번호
  let phoneNumber: String
  /// 유저 아이디
  let id: Int
  /// 유저 이름
  let name: String

  // MARK: - Init

  init(phoneNumber: String, id: Int, name: String) {
    self.phoneNumber = phoneNumber
    self.id = id
    self.name = name
  }

  convenience init(id: Int) {
    self.init(phoneNumber: "",id: id, name: "")
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: UserKeys.self)
    self.phoneNumber = (try? container.decode(String.self, forKey: .phoneNumber)) ?? ""
    self.id = try container.decode(Int.self, forKey: .id)
    self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
  }
}
