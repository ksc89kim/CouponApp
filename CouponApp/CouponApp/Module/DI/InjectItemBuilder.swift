//
//  InjectItemBuilder.swift
//  CouponApp
//
//  Created by kim sunchul on 2023/06/17.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation

@resultBuilder
struct InjectItemBuilder {

  static func buildBlock(_ components: InjectItem...) -> [InjectItem] {
    return components
  }

  static func buildBlock(_ component: InjectItem) -> InjectItem {
    return component
  }
}
