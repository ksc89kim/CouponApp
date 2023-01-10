//
//  CheckCouponModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

/// 쿠폰 존재 여부
struct ExistenceCoupon: Codable {

  // MARK: - Define

  private enum ExistenceCouponKeys: String, CodingKey {
    case isCouponData
  }

  //MARK: - Property

  /// 쿠폰 여부
  let isCouponData: Bool

  //MARK: - Init

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: ExistenceCouponKeys.self)
    self.isCouponData = try container.decode(Bool.self, forKey: .isCouponData)
  }
}
