//
//  UINibExtensions.swift
//  CouponApp
//
//  Created by kim sunchul on 2022/05/06.
//  Copyright © 2022 kim sunchul. All rights reserved.
//

import UIKit

extension UINib {
  convenience init(type: CouponNibName) {
    self.init(nibName: type.rawValue, bundle: nil)
  }
}
