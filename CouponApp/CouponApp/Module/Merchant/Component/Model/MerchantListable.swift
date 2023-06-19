//
//  MerchantListable.swift
//  CouponApp
//
//  Created by kim sunchul on 2023/06/19.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation

enum MerchantListKey: InjectionKey {
  typealias Value = MerchantListable
}


protocol MerchantListable: Listable, Injectable where ListType == MerchantType {
  func index(merchantID: Int?) -> MerchantType?
}
