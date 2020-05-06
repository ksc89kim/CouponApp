//
//  CouponProtocol.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 7..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

protocol Coupon {
    var couponId:Int { get }
    var isEvent:Bool { get set }
}
