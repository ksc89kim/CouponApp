//
//  CouponSectionModel.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/01/27.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

struct CouponSection: SectionModelType {

  // MARK: - Property

  var items: [CouponUIType]

  // MARK: - Init

  init(items: [CouponUIType]) {
    self.items = items
  }

  init(original: CouponSection, items: [CouponUIType]) {
    self = original
    self.items = items
  }
}
