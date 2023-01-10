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
    self.list.remove(at: at)
  }
  
  subscript(index: Int) -> ListType? {
    get {
      return self.list[index]
    }
    set(newValue) {
      self.list[index] = newValue!
    }
  }
}
