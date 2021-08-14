//
//  CPUNSLayoutContraint.swift
//  CouponApp
//
//  Created by kim sunchul on 11/08/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
  func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
    return NSLayoutConstraint(
      item: self.firstItem!,
      attribute: self.firstAttribute,
      relatedBy: self.relation,
      toItem: self.secondItem,
      attribute: self.secondAttribute,
      multiplier: multiplier,
      constant: self.constant
    )
  }
}
