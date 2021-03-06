//
//  RoundedView.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 19..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/// 라운드 뷰
@IBDesignable class RoundedView: UIView {

  // MARK: - Properties

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

  // MARK: - Life Cycle

  override func layoutSubviews() {
    super.layoutSubviews()
    self.updateCornerRadius()
  }

  // MARK: - Update

  private func updateCornerRadius() {
    self.layer.cornerRadius = self.rounded ? self.cornerRadius : 0
    self.layer.masksToBounds = self.rounded ? true : false
  }
}
