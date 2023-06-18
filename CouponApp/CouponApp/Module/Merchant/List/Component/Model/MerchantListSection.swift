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

  var items: [MerchantType]

  // MARK: - Init

  init(items: [MerchantType]) {
    self.items = items
  }

  init(original: MerchantListSection, items: [MerchantType]) {
    self = original
    self.items = items
  }
}
