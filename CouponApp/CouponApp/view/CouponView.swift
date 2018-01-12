//
//  CouponView.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 11..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

class CouponView: UIView {
    var isUseCoupone:Bool = true // 쿠폰 체크박스 여부
    var isImageCoupon:Bool = false // 이미지 쿠폰 존재 여부
    
    func refreshCoupon(couponStatus:Bool) {
        isUseCoupone = couponStatus
        refreshDisplay()
    }
    
    //이미지 갱신
    func refreshDisplay() {
    }
}
