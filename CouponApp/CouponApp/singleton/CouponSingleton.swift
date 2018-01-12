//
//  CouponSingleton.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 1. 7..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation

// 쿠폰 전체앱 싱글톤 클래스
class CouponSignleton {
    static let sharedInstance = CouponSignleton()
    var userId:Int? = 1
    var merchantList:[MerchantModel?]? //가맹점 리스트
    
    // MARK: - 가맹점 데이터 리스트 생성
    func createMerchantList() {
        do {
            CouponSignleton.sharedInstance.merchantList = try SQLInterface().selectMerchantData()
            for merchantModel in merchantList! {
                merchantModel?.drawCouponList = try SQLInterface().selecDrawCouponData(merchantId: (merchantModel?.merchantId)!)
            }
        } catch {
            print(error)
        }
    }
    
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
