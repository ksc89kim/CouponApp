//
//  UserMerchantSection.swift
//  CouponApp
//
//  Created by kim sunchul on 2023/04/05.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

struct UserMerchantSection: SectionModelType {

  // MARK: - Property

  var items: [MerchantType]

  // MARK: - Init

  init(items: [MerchantType]) {
    self.items = items
  }

  init(original: UserMerchantSection, items: [MerchantType]) {
    self = original
    self.items = items
  }
}
