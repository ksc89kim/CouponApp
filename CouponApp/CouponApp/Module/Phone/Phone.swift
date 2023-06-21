//
//  Phone.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/01/12.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation

enum PhoneKey: InjectionKey {
  typealias Value = PhoneType
}


protocol PhoneType: Injectable {
  func saveNumber(_ number: String)
  func loadNumber() -> String?
}


final class Phone: PhoneType {

  func saveNumber(_ number: String) {
    UserDefaults.standard.set(number, forKey: DefaultKey.phoneNumber.rawValue)
  }

  func loadNumber() -> String? {
    return UserDefaults.standard.string(forKey: DefaultKey.phoneNumber.rawValue)
  }
}
