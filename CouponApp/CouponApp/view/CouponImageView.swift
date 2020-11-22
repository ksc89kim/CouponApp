//
//  CouponImageView.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 11..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/// 쿠폰 이미지 뷰
/// - UIImageView를 통한 쿠폰 이미지 뷰
final class CouponImageView: UIView , CouponView {
  
  // MARK: - UI Component

  @IBOutlet var couponImage: UIImageView!

  // MARK: - Properties

  var uiData: CouponUI? {
    didSet {
      self.updateUI()
    }
  }

  // MARK: - LifeCyecle

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  // MARK: - Update

  func updateUI() {
    if let imageCoupon = uiData as? ImageCoupon {
      let imagePath = imageCoupon.isUseCoupon ? imageCoupon.selectImage:imageCoupon.normalImage
      self.couponImage.image = UIImage(named: imagePath)
    }
  }
}
