//
//  DrawCouponModel.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 12..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/*
     쿠폰 그리기 데이터
*/

struct DrawCouponModel:Codable, MerchantProtocol, CouponProtocol {
    var couponId:Int // 쿠폰 인덱스
    var merchantId:Int // 가맹점 ID
    var circleColor:String // 원 색상
    var ringColor:String // 테두리 색상
    var ringThickness:CGFloat // 테두리 굵기
    var isRing:Bool // 테두리 여부
    var checkLineWidth:CGFloat // 쿠폰 체크박스 굵기
    var checkLineColor:String // 쿠폰 체크 박스 색상
    var isEvent:Bool // 이벤트 여부
    
    private enum DrawCouponKeys: String, CodingKey {
        case couponId = "coupon_id"
        case merchantId = "merchant_id"
        case circleColor = "circle_color"
        case ringColor = "ring_color"
        case ringThickness = "ring_thickness"
        case isRing
        case checkLineWidth = "checkline_width"
        case checkLineColor = "checkline_color"
        case isEvent = "isEvent"
    }
    
    init() {
        self.couponId = 0
        self.merchantId = 0
        self.circleColor = "FFFEE9"
        self.ringColor = "FFCE0D"
        self.ringThickness = 0
        self.isRing = true
        self.checkLineColor = "000000"
        self.checkLineWidth = 0
        self.isEvent = false
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DrawCouponKeys.self)
        self.couponId = try container.decode(Int.self, forKey: .couponId)
        self.merchantId = try container.decode(Int.self, forKey: .merchantId)
        self.isEvent = try container.decode(Bool.self, forKey: .isEvent)
        self.isRing = try container.decode(Bool.self, forKey: .isRing)
        self.ringThickness = try container.decode(CGFloat.self, forKey: .ringThickness)
        self.checkLineWidth = try container.decode(CGFloat.self, forKey: .checkLineWidth)
        self.ringColor = try container.decode(String.self, forKey: .ringColor)
        self.circleColor = try container.decode(String.self, forKey: .circleColor)
        self.checkLineColor = try container.decode(String.self, forKey: .checkLineColor)
    }
}
