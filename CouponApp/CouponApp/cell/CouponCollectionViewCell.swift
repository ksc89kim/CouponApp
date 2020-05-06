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
    
    func refreshView(coupon:CouponUI) {
        let imageCoupon:ImageCoupon? = coupon as? ImageCoupon
        if imageCoupon != nil {
            drawView.isHidden = true
            imageView.isHidden = false
            imageView.imageCoupon = imageCoupon
        } else {
            drawView.isHidden = false
            imageView.isHidden = true
            drawView.drawCoupon = coupon as? DrawCoupon
        }
    }
    
}
