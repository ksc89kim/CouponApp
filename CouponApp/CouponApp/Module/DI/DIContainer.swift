//
//  DIContainer.swift
//  CouponApp
//
//  Created by kim sunchul on 2023/06/17.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation

final class DIContainer {

  // MARK: - Property

  static var instance: DIContainer = .init()
  private var items: [String: InjectItem] = [:]

  // MARK: - Method
  
  static func resolve<T>(for type: Any.Type?) -> T {
    let name = type.map { (type: Any.Type) -> String in
      return String(describing: type)
    } ?? String(describing: T.self)

    guard let injectable = self.instance.items[name]?.resolve() as? T else {
      fatalError("Dependency \(T.self) not resolved")
    }
    return injectable
  }

  static func register(@InjectItemBuilder _ items: () -> [InjectItem]) {
    items().forEach { (item: InjectItem) in
      self.instance.add(item)
    }
  }

  static func register(@InjectItemBuilder _ item: () -> InjectItem) {
    self.instance.add(item())
  }

  func add(_ item: InjectItem) {
    self.items[item.name] = item
  }
}
