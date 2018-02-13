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
class ImageCouponModel:ParseProtocol{
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
    
    func parseData(data:[String:Any]){
        self.merchantId =  data["merchant_id"] as? Int
        self.couponId = data["coupon_id"] as? Int
        self.normalImageString = data["normal_image"] as! String
        self.selectImageString = data["select_image"] as! String
        self.isEvent = data["isEvent"] as! Bool
    }
}
