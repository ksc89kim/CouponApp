//
//  CustomPopup.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/11/15.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift

struct CustomPopup {

  // MARK: - Property

  let title: String
  let message: String
  let callback: AnyObserver<Void>?
}
