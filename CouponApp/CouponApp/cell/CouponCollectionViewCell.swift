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
    
    func refreshView(_ isUseCoupon:Bool, isAnimaton:Bool, couponProtocol:CouponProtocol) {
        let imageModel:ImageCouponModel? = couponProtocol as? ImageCouponModel
        if imageModel != nil {
            drawView.isHidden = true
            imageView.isHidden = false
            imageView.model = imageModel
            imageView.isUseCoupon = isUseCoupon
        } else {
            drawView.isHidden = false
            imageView.isHidden = true
            drawView.isCheckBoxAnimation = isAnimaton
            drawView.model = couponProtocol as? DrawCouponModel
            drawView.isUseCoupon = isUseCoupon
        }
    }
    
}
