//
//  ImageCouponModel.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

/*
     쿠폰 이미지 데이터
*/
struct ImageCouponModel {
    var couponId:Int? // 쿠폰 인덱스
    var merchantId:Int? // 가맹점 ID
    var isEvent:Bool // 이벤트 여부
    var normalImageString:String // 평소 이미지
    var selectImageString:String // 선택된 이미지
    
    init() {
        isEvent = false
        normalImageString = ""
        selectImageString = ""
    }
}
