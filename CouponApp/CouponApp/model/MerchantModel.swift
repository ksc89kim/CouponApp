//
//  MerchantModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 12. 6..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import Foundation

/* 가맹점 데이터 */

class MerchantModel {
    var merchantId:Int? // 가맹점 ID
    var name:String? // 가맹점 이름
    var content:String? // 가맹점 소개 내용
    var logoImageUrl:String? //로고 이미지 url
    var latitude:Double? //위도
    var longitude:Double? //경도
    var isCouponImage:Bool? //쿠폰 이미지 여부
    var drawCouponList:[DrawCouponModel?]?
    
    init() {
        merchantId = 0
        name = ""
        content = ""
        logoImageUrl = ""
        latitude = 0
        longitude = 0
        isCouponImage = false
    }
}
