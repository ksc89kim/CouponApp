//
//  CouponCollectionViewCell.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 16..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

final class CouponCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var drawView: CouponDrawView!
    @IBOutlet weak var imageView: CouponImageView!
    
    func updateUI(coupon:CouponUI) {
        if coupon is ImageCoupon {
            drawView.isHidden = true
            imageView.isHidden = false
            imageView.uiData = coupon
        } else {
            drawView.isHidden = false
            imageView.isHidden = true
            drawView.uiData = coupon
        }
    }
    
}
