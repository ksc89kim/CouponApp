//
//  Alert.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/11/15.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import Foundation

enum AlertKey: InjectionKey {
  typealias Value = Alert
}


struct Alert: Injectable {

  // MARK: - Property

  var title: String
  var message: String

  init() {
    self.title = ""
    self.message = ""
  }
}
