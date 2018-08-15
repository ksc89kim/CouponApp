//
//  MerchantListModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 7..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

struct MerchantListModel:Codable, ListProtocol {
    var list:[MerchantModel]
    
    init() {
        self.list = []
    }
    
    private enum MerchantListKeys: String, CodingKey {
        case list = "merchantInfoArray"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MerchantListKeys.self)
        self.list = try container.decode([MerchantModel].self, forKey: .list)
    }
    
    func findMerchantModel(merchantId:Int?) -> MerchantModel? {
        var fModel:MerchantModel? = nil;
        for model in list {
            if model.merchantId == merchantId {
                fModel = model
                break;
            }
        }
        return fModel
    }
}
