//
//  MerchantModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 12. 6..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import Foundation

/*
     가맹점 데이터
*/

struct MerchantModel:Codable,  MerchantProtocol {
    var merchantId:Int // 가맹점 ID
    var name:String // 가맹점 이름
    var content:String // 가맹점 소개 내용
    var logoImageUrl:String //로고 이미지 url
    var latitude:Double //위도
    var longitude:Double //경도
    var isCouponImage:Bool //쿠폰 이미지 여부
    var imageCouponList:[ImageCouponModel] //쿠폰 이미지 데이터
    var drawCouponList:[DrawCouponModel] //쿠폰 그리기 데이터
    
    init() {
        self.merchantId = 0
        self.name = ""
        self.content = ""
        self.logoImageUrl = ""
        self.latitude = 0
        self.longitude = 0
        self.isCouponImage = false
        self.imageCouponList = []
        self.drawCouponList = []
    }
    
    private enum MerchantKeys: String, CodingKey {
        case merchantId = "id"
        case name
        case content
        case logoImageUrl = "imageUrl"
        case latitude
        case longitude
        case isCouponImage
        case imageCouponList
        case drawCouponList
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MerchantKeys.self)
        self.merchantId = try container.decode(Int.self, forKey: .merchantId)
        self.name = try container.decode(String.self, forKey: .name)
        self.content = try container.decode(String.self, forKey: .content)
        self.logoImageUrl = try container.decode(String.self, forKey: .logoImageUrl)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.isCouponImage = try container.decode(Bool.self, forKey: .isCouponImage)
        self.drawCouponList = (try? container.decode([DrawCouponModel].self, forKey: .drawCouponList)) ?? []
        self.imageCouponList = (try? container.decode([ImageCouponModel].self, forKey: .imageCouponList)) ?? []
    }
    
    func couponCount() -> Int {
        return isCouponImage ? imageCouponList.count : drawCouponList.count
    }
}
