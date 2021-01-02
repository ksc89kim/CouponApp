//
//  CouponCollectionViewCell.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 16..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

final class CouponCollectionViewCell: UICollectionViewCell {
  
  // MARK: -  UI Components
  
  @IBOutlet weak var drawView: CouponDrawView!
  @IBOutlet weak var imageView: CouponImageView!
  
  // MARK: -  Update
  
  func updateUI(coupon: CouponUI) {
    if coupon is ImageCoupon {
      self.drawView.isHidden = true
      self.imageView.isHidden = false
      self.imageView.uiData = coupon
    } else {
      self.drawView.isHidden = false
      self.imageView.isHidden = true
      self.drawView.uiData = coupon
    }
  }
  
}
