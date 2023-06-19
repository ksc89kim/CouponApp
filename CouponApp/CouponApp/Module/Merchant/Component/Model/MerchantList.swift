//
//  MerchantList.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 7..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

struct MerchantList: Codable, MerchantListable {

  //MARK: - Define

  private enum Keys: String, CodingKey {
    case list = "MerchantList"
  }

  //MARK: - Property

  var list: [MerchantType]

  //MARK: - Init

  init() {
    self.list = []
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Keys.self)
    self.list = try container.decode([Merchant].self, forKey: .list)
  }

  //MARK: - Method

  func index(merchantID: Int?) -> MerchantType? {
    return self.list.first { (merchant: MerchantType) in
      return merchant.merchantID == merchantID
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: Keys.self)
    let list = self.list.compactMap { $0 as? Merchant }
    try container.encode(list, forKey: .list)
  }
}
