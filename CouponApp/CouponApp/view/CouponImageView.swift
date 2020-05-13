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
final class CouponImageView: UIView , CouponView{
    @IBOutlet var couponImage:UIImageView!
    var uiData: CouponUI? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        if let imageCoupon = uiData as? ImageCoupon {
            let imagePath = imageCoupon.isUseCoupon ? imageCoupon.selectImage:imageCoupon.normalImage
            couponImage.image = UIImage(named: imagePath)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
