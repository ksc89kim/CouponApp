//
//  ListProtocol.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

protocol Listable {
  associatedtype ListType
  var list: [ListType] { get set }
  var count: Int { get }
  mutating func append(_ item: ListType)
  mutating func remove(_ at: Int)
  func filter(isIncluded: (ListType) throws -> Bool) rethrows ->  [ListType]
  subscript(index: Int) -> ListType? { get set }
}


extension Listable {
  var count:Int {
    return self.list.count
  }
  
  mutating func append(_ item: ListType) {
    self.list.append(item)
  }
  
  mutating func remove(_ at: Int) {
    guard self.list.indices ~= at else { return }
    self.list.remove(at: at)
  }

  func filter(
    isIncluded: (ListType) throws -> Bool
  ) rethrows ->  [ListType] {
    return try self.list.filter(isIncluded)
  }
  
  subscript(index: Int) -> ListType? {
    get {
      guard self.list.indices ~= index else { return nil }
      return self.list[index]
    }
    set(newValue) {
      self.list[index] = newValue!
    }
  }
}
