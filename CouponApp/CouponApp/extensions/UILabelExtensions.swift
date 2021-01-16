//
//  CPUILabel.swift
//  CouponApp
//
//  Created by kim sunchul on 2019. 4. 14..
//  Copyright © 2019년 kim sunchul. All rights reserved.
//

import UIKit

extension UILabel {
  func copyLabel() -> UILabel {
    let label = UILabel()
    label.font = self.font
    label.frame = self.frame
    label.text = self.text
    return label
  }
  
  var optimalWidth : CGFloat
  {
    get
    {
      let label = UILabel(
        frame: CGRect(
          x: 0,
          y: 0,
          width: CGFloat.greatestFiniteMagnitude,
          height:self.frame.size.height
        )
      )
      label.numberOfLines = 0
      label.lineBreakMode = self.lineBreakMode
      label.font = self.font
      label.text = self.text
      label.sizeToFit()
      return label.frame.height
    }
  }
}
