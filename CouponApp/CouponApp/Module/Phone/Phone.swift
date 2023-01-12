//
//  Phone.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/01/12.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation

final class Phone {

  func saveNumber(_ number: String) {
    UserDefaults.standard.set(number, forKey: DefaultKey.phoneNumber.rawValue)
  }

  func loadNumber() -> String? {
    return UserDefaults.standard.string(forKey: DefaultKey.phoneNumber.rawValue)
  }
}
