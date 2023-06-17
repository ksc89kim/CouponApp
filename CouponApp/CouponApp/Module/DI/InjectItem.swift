//
//  InjectItem.swift
//  CouponApp
//
//  Created by kim sunchul on 2023/06/17.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation

struct InjectItem {

  // MARK: - Property

  let name: String
  let resolve: () -> Injectable

  // MARK: - Init

  init<T: InjectionKey>(
    _ name: T.Type,
    resolve: @escaping () -> Injectable
  ) {
    self.name = String(describing: name)
    self.resolve = resolve
  }
}
