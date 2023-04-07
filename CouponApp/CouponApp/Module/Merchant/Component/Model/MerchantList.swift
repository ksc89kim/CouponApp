//
//  MerchantList.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 7..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

struct MerchantList: Codable, Listable {

  //MARK: - Define

  private enum MerchantListKeys: String, CodingKey {
    case list = "MerchantList"
  }

  //MARK: - Property

  var list: [Merchant]

  //MARK: - Init

  init() {
    self.list = []
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MerchantListKeys.self)
    self.list = try container.decode([Merchant].self, forKey: .list)
  }

  //MARK: - Method

  func index(merchantID: Int?) -> Merchant? {
    return self.list.first { (merchant: Merchant) in
      return merchant.merchantID == merchantID
    }
  }
}
