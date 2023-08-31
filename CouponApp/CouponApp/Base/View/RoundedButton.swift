//
//  RoundedButton.swift
//  CouponApp
//
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/// 라운드 버튼
@IBDesignable
class RoundedButton: UIButton {

  // MARK: - Life Cycle

  override func layoutSubviews() {
    super.layoutSubviews()
    self.updateCornerRadius()
  }

  // MARK: - Property

  @IBInspectable var rounded: Bool = false {
    didSet {
      self.updateCornerRadius()
    }
  }
  
  @IBInspectable var cornerRadius: CGFloat = 0.1 {
    didSet {
      self.updateCornerRadius()
    }
  }

  // MARK: - Method

  func updateCornerRadius() {
    self.layer.cornerRadius = self.rounded ? self.cornerRadius : 0
    self.layer.masksToBounds = self.rounded ? true : false
  }
}
