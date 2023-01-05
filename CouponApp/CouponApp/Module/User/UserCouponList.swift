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

  private enum UserCouponListKeys: String, CodingKey {
    case list = "couponInfoArray"
  }

  // MARK: - Property

  var list: [UserCoupon]

  // MARK: - Init

  init() {
    self.list = []
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: UserCouponListKeys.self)
    self.list = try container.decode([UserCoupon].self, forKey: .list)
  }
}
