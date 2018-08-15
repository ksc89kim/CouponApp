//
//  UserCouponListModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

class UserCouponListModel:Codable, ListProtocol{
    var list: [UserCouponModel]
    
    init() {
       list = []
    }
    
    private enum UserCouponListKeys: String, CodingKey {
        case list = "couponInfoArray"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserCouponListKeys.self)
        self.list = try container.decode([UserCouponModel].self, forKey: .list)
    }
}
