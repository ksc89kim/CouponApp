//
//  ImageCouponModel.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation
import FMDB

/*
     쿠폰 이미지 데이터
*/

class ImageCouponModel:Codable, MerchantProtocol, CouponProtocol {
    var couponId:Int // 쿠폰 인덱스
    var merchantId:Int // 가맹점 ID
    var isEvent:Bool // 이벤트 여부
    let normalImage:String // 평소 이미지
    let selectImage:String // 선택된 이미지
    
    private enum ImageCouponKeys: String, CodingKey {
        case couponId = "coupon_id"
        case merchantId = "merchant_id"
        case isEvent = "isEvent"
        case normalImage = "normal_image"
        case selectImage = "select_image"
    }
    
    init(couponId:Int,merchantId:Int,isEvent:Bool, normalImage:String, selectImage:String) {
        self.couponId = couponId
        self.merchantId = merchantId
        self.isEvent = isEvent
        self.normalImage = normalImage
        self.selectImage = selectImage
    }
    
    convenience init(resultSet:FMResultSet) {
        let merchantIdx:Int32 = resultSet.int(forColumnIndex: 0)
        let couponIdx:Int32 = resultSet.int(forColumnIndex: 1)
        let normalImage:String = resultSet.string(forColumnIndex: 2) ?? ""
        let selectImage:String = resultSet.string(forColumnIndex: 3) ?? ""
        let isEvent:Bool = resultSet.bool(forColumnIndex: 4)
        
        self.init(couponId: Int(couponIdx), merchantId: Int(merchantIdx), isEvent:isEvent, normalImage:normalImage, selectImage:selectImage)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ImageCouponKeys.self)
        self.couponId = try container.decode(Int.self, forKey: .couponId)
        self.merchantId = try container.decode(Int.self, forKey: .merchantId)
        self.isEvent = try container.decode(Bool.self, forKey: .isEvent)
        self.normalImage = try container.decode(String.self, forKey: .normalImage)
        self.selectImage = try container.decode(String.self, forKey: .selectImage)
    }
}
