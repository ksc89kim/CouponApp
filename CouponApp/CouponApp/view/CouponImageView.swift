//
//  CouponImageView.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 11..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

class CouponImageView: CouponView {

    override func awakeFromNib() {
        super.awakeFromNib()
        //custom logic goes here
    }
    
    override func refreshDisplay() {
        super.refreshDisplay()
        if isImageCoupon {
            self.isHidden = false
        } else {
            self.isHidden = true
        }
    }
}
