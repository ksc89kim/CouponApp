//
//  UserCouponListModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

final class UserCouponList: Codable, Listable {

  // MARK: - Define

  private enum Keys: String, CodingKey {
    case list = "couponInfoArray"
  }

  // MARK: - Property

  var list: [UserCouponType]

  // MARK: - Init

  init() {
    self.list = []
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Keys.self)
    self.list = try container.decode([UserCoupon].self, forKey: .list)
  }

  // MARK: - Encode

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: Keys.self)
    let list = self.list.compactMap { $0 as? UserCoupon }
    try container.encode(list, forKey: .list)
  }
}
