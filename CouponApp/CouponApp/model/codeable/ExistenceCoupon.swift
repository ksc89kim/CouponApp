//
//  CheckCouponModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

struct ExistenceCoupon:Codable {
    let isCouponData:Bool //쿠폰 여부
    
    private enum ExistenceCouponKeys: String, CodingKey {
        case isCouponData
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ExistenceCouponKeys.self)
        self.isCouponData = try container.decode(Bool.self, forKey: .isCouponData)
    }
}
