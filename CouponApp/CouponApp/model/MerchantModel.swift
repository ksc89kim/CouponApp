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
class MerchantModel:ParseProtocol{
    var merchantId:Int? // 가맹점 ID
    var name:String? // 가맹점 이름
    var content:String? // 가맹점 소개 내용
    var logoImageUrl:String? //로고 이미지 url
    var latitude:Double? //위도
    var longitude:Double? //경도
    var isCouponImage:Bool? //쿠폰 이미지 여부
    var imageCouponList:[ImageCouponModel?]? //쿠폰 이미지 데이터
    var drawCouponList:[DrawCouponModel?]? //쿠폰 그리기 데이터
    
    init() {
        merchantId = 0
        name = ""
        content = ""
        logoImageUrl = ""
        latitude = 0
        longitude = 0
        isCouponImage = false
        imageCouponList = [ImageCouponModel?]()
        drawCouponList = [DrawCouponModel?]()
    }
    
    func parseData(data: [String : Any]) {
        self.merchantId =  data["id"] as? Int
        self.name = data["name"] as? String
        self.content = data["content"] as? String
        self.logoImageUrl = data["imageUrl"] as? String
        self.latitude = data["latitude"] as? Double
        self.longitude = data["longitude"] as? Double
        self.isCouponImage = data["isCouponImage"] as? Bool
        
        if let imageCouponList = data["imageCouponList"] as? [[String:Any]] {
            for imageCouponJsonData in imageCouponList {
                let imageCouponModel = ImageCouponModel()
                imageCouponModel.parseData(data: imageCouponJsonData)
                self.imageCouponList?.append(imageCouponModel)
            }
        }
        
        if let drawCouponList = data["drawCouponList"] as? [[String:Any]] {
            for drawCouponJsonData in drawCouponList {
                let drawCouponModel = DrawCouponModel()
                drawCouponModel.parseData(data: drawCouponJsonData)
                self.drawCouponList?.append(drawCouponModel)
            }
        }
    }
}
