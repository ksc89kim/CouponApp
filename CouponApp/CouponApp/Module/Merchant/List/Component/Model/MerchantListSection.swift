//
//  MerchantListSection.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/02/03.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources


struct MerchantListSection: SectionModelType {

  // MARK: - Property

  var items: [Merchant]

  // MARK: - Init

  init(items: [Merchant]) {
    self.items = items
  }

  init(original: MerchantListSection, items: [Merchant]) {
    self = original
    self.items = items
  }
}
