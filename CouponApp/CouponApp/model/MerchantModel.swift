//
//  MerchantModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 12. 6..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import Foundation

/* 가맹점 데이터 */

struct MerchantModel {
    var merchantId:Int? // 가맹점 ID
    var name:String? // 가맹점 이름
    var content:String? // 가맹점 소개 내용
    var maxCouponCount:Int? //최대 쿠폰 갯수
    var logoImageUrl:String? //로고 이미지 url
    var latitude:Double? //위도
    var longitude:Double? //경도
    init() {
        maxCouponCount = 0
        name = ""
        content = ""
        maxCouponCount = 0
        logoImageUrl = ""
        latitude = 0
        longitude = 0
    }
}
