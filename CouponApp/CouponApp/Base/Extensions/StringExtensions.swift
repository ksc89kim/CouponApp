//
//  CPString.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 7. 26..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

extension String {
  
  func replace(target: String, withString: String) -> String {
    return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
  }

  var localized: String {
    return NSLocalizedString(self,comment:"")
  }

  func size(OfFont font: UIFont) -> CGSize {
    return (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
  }

  func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(
      with: constraintRect,
      options: .usesLineFragmentOrigin,
      attributes: [NSAttributedString.Key.font: font],
      context: nil
    )
    return ceil(boundingBox.height)
  }

  func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox = self.boundingRect(
      with: constraintRect,
      options: .usesLineFragmentOrigin,
      attributes: [NSAttributedString.Key.font: font],
      context: nil
    )
    return ceil(boundingBox.width)
  }
}
