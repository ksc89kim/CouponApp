//
//  InjectionKey.swift
//  CouponApp
//
//  Created by kim sunchul on 2023/06/17.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation

protocol InjectionKey {
  associatedtype Value
  static var currentValue: Self.Value { get }
}


extension InjectionKey {

  static var currentValue: Value {
    return DIContainer.resolve(for: Self.self)
  }
}
