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
class CouponSignleton {
    static let instance = CouponSignleton()
    var networkData:NetworkModel? = NetworkModel()
    var userData:UserModel? = UserModel()
    var merchantList:[MerchantModel?]? //가맹점 리스트
    
    
    // MARK: - 가맹점 데이터 찾기
    func findMerchantModel(merchantId:Int?) -> MerchantModel? {
        var fMerchantModel:MerchantModel? = nil;
        for merchantModel in merchantList! {
            if merchantModel?.merchantId == merchantId {
                fMerchantModel = merchantModel
                break;
            }
        }
        return fMerchantModel
    }
    

}
