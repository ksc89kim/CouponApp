//
//  CouponImageView.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 11..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/*
     쿠폰 이미지 뷰
     - UIImageView를 통한 쿠폰 이미지 뷰
 */
class CouponImageView: UIView, CouponView {
    var isUseCoupon: Bool = false{
        didSet {
            if isUseCoupon {
                couponImage.image = UIImage(named: (imageCoupon?.selectImage)!)
            } else {
                couponImage.image = UIImage(named: (imageCoupon?.normalImage)!)
            }
        }
    }
    
    var imageCoupon:ImageCoupon?
    
    @IBOutlet var couponImage:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
