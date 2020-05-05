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
class CouponImageView: UIView, CouponViewProtocol {
    var isUseCoupon: Bool = false{
        didSet {
            if isUseCoupon {
                couponImage.image = UIImage(named: (model?.selectImage)!)
            } else {
                couponImage.image = UIImage(named: (model?.normalImage)!)
            }
        }
    }
    
    var model:ImageCouponModel?
    @IBOutlet var couponImage:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
