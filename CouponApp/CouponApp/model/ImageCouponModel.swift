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

struct ImageCouponModel:Codable, MerchantProtocol, CouponProtocol {
    var couponId:Int // 쿠폰 인덱스
    var merchantId:Int // 가맹점 ID
    var isEvent:Bool // 이벤트 여부
    var normalImage:String // 평소 이미지
    var selectImage:String // 선택된 이미지
    
    init(){
        self.couponId = 0
        self.merchantId = 0
        self.isEvent = false
        self.normalImage = ""
        self.selectImage = ""
    }
    
    private enum ImageCouponKeys: String, CodingKey {
        case couponId = "coupon_id"
        case merchantId = "merchant_id"
        case isEvent = "isEvent"
        case normalImage = "normal_image"
        case selectImage = "select_image"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ImageCouponKeys.self)
        self.couponId = try container.decode(Int.self, forKey: .couponId)
        self.merchantId = try container.decode(Int.self, forKey: .merchantId)
        self.isEvent = try container.decode(Bool.self, forKey: .isEvent)
        self.normalImage = try container.decode(String.self, forKey: .normalImage)
        self.selectImage = try container.decode(String.self, forKey: .selectImage)
    }
}
