//
//  MerchantListModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 7..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

struct MerchantImplList: Codable, List {

  //MARK: - Define

  private enum MerchantImplListKeys: String, CodingKey {
    case list = "merchantImplList"
  }

  //MARK: - Property

  var list: [MerchantImpl]

  //MARK: - Init

  init() {
    self.list = []
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MerchantImplListKeys.self)
    self.list = try container.decode([MerchantImpl].self, forKey: .list)
  }

  //MARK: - Method

  func index(merchantId: Int?) -> MerchantImpl? {
    var indexMerchant: MerchantImpl? = nil;
    for merchant in list {
      if merchant.merchantId == merchantId {
        indexMerchant = merchant
        break;
      }
    }
    return indexMerchant
  }
}
