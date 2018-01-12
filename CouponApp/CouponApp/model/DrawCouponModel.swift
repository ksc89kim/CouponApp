//
//  DrawCouponModel.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 12..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit


/* 쿠폰 그리기 데이터 */

struct DrawCouponModel {
    var couponId:Int? // 쿠폰 인덱스
    var merchantId:Int? // 가맹점 ID
    var circleColor:UIColor // 원 색상
    var ringColor:UIColor // 테두리 색상
    var ringThickness:CGFloat // 테두리 굵기
    var isRing:Bool // 테두리 여부
    var checkLineWidth:CGFloat // 쿠폰 체크박스 굵기
    var checkLineColor:UIColor // 쿠폰 체크 박스 색상
    var isEvent:Bool // 이벤트 여부
    
    init() {
        circleColor = UIColor.hexStringToUIColor(hex: "FFFEE9")
        ringColor = UIColor.hexStringToUIColor(hex: "FFCE0D")
        ringThickness = 4
        isRing = true
        checkLineWidth = 4
        checkLineColor = UIColor.black
        isEvent = false
    }
}
