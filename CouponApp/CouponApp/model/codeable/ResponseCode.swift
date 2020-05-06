//
//  RespCodeModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

struct ResponseCode: Codable {
    var isSuccess:Bool
    
    private enum ResponseCodeKeys: String, CodingKey {
        case isSuccess
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseCodeKeys.self)
        self.isSuccess = try container.decode(Bool.self, forKey: .isSuccess)
    }
}
