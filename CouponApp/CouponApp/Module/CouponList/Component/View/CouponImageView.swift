//
//  CouponImageView.swift
//  CouponApp
//
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/// 쿠폰 이미지 뷰
/// - UIImageView를 통한 쿠폰 이미지 뷰
final class CouponImageView: UIView , CouponViewType {
  
  // MARK: - UI Component

  @IBOutlet var couponImage: UIImageView!

  // MARK: - Property

  var uiData: CouponUIType? {
    didSet {
      self.updateUI()
    }
  }

  // MARK: - Life Cyecle

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  // MARK: - Update

  func updateUI() {
    if let imageCoupon = uiData as? ImageCoupon {
      let imagePath = imageCoupon.isUseCoupon ? imageCoupon.selectImage : imageCoupon.normalImage
      self.couponImage.image = UIImage(named: imagePath)
    }
  }
}
