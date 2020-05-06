//
//  MerchantListModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 7..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

struct MerchantImplList:Codable, List {
    var list:[MerchantImpl]
    
    init() {
        self.list = []
    }
    
    private enum MerchantImplListKeys: String, CodingKey {
        case list = "merchantImplList"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MerchantImplListKeys.self)
        self.list = try container.decode([MerchantImpl].self, forKey: .list)
    }
    
    func index(merchantId:Int?) -> MerchantImpl? {
        var indexMerchant:MerchantImpl? = nil;
        for merchant in list {
            if merchant.merchantId == merchantId {
                indexMerchant = merchant
                break;
            }
        }
        return indexMerchant
    }
}
