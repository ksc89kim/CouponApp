//
//  CouponSingleton.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 1. 7..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit

/*
     쿠폰 전체앱 싱글톤 클래스
 */
final class CouponSignleton {
    static let instance = CouponSignleton()
    var userData:User?
    var merchantList:MerchantImplList?
}
