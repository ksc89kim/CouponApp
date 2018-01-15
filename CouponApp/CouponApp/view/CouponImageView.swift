//
//  CouponImageView.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 11..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

class CouponImageView: CouponView {
    var model:ImageCouponModel?
    @IBOutlet var couponImage:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        model = ImageCouponModel()
    }
    
    override func refreshDisplay() {
        super.refreshDisplay()
        if isImageCoupon {
            self.isHidden = false
            if isUseCoupone {
                couponImage.image = UIImage(named: (model?.selectImageString)!)
            } else {
                couponImage.image = UIImage(named: (model?.normalImageString)!)
            }
        } else {
            self.isHidden = true
        }
    }
}
