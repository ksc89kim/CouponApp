//
//  CouponCollectionViewCell.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 16..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

class CouponCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var drawView: CouponDrawView!
    @IBOutlet weak var imageView: CouponImageView!
    
    func refreshView(_ isUseCoupon:Bool, isAnimaton:Bool, coupon:Coupon) {
        let imageCoupon:ImageCoupon? = coupon as? ImageCoupon
        if imageCoupon != nil {
            drawView.isHidden = true
            imageView.isHidden = false
            imageView.imageCoupon = imageCoupon
            imageView.isUseCoupon = isUseCoupon
        } else {
            drawView.isHidden = false
            imageView.isHidden = true
            drawView.isCheckBoxAnimation = isAnimaton
            drawView.drawCoupon = coupon as? DrawCoupon
            drawView.isUseCoupon = isUseCoupon
        }
    }
    
}
