//
//  Inject.swift
//  CouponApp
//
//  Created by kim sunchul on 2023/06/17.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation

@propertyWrapper
final class Inject<Value> {

  // MARK: - Property

  private let lazyValue: (() -> Value)
  private var storage: Value?

  var wrappedValue: Value {
    self.storage ?? {
      let value: Value = lazyValue()
      self.storage = value
      return value
    }()
  }

  // MARK: - Init

  init<Key: InjectionKey>(_ key: Key.Type) where Value == Key.Value {
    self.lazyValue = {
      key.currentValue
    }
  }
}
