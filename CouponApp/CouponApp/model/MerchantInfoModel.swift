//
//  MerchantInfoModel.swift
//  CouponApp
//
//  Created by kim sunchul on 06/05/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import UIKit

struct MerchantInfoModel {
    var originalHeaderHeight:CGFloat = 0     //기존 헤더 높이
    var merchantModel:MerchantModel? // 가맹점 정보
    var isUserCoupon:Bool = false // 사용자 쿠폰 여부
    var positionY:CGFloat = 0// 애니메이션 시작점 Y

    // 이전 셀에 대한 정보
    weak var cellTopView:UIView?
    weak var cellTopLogoImage:UIImage?

    // 폰트 관련 정보
    var titleFontSize:CGFloat = 30
    var cellFontSize:CGFloat = 17
    
    mutating func setData(model:MerchantModel?, topView:UIView, animationY:CGFloat) {
        self.merchantModel = model
        self.cellTopView = topView
        self.positionY = animationY
    }
        
    func getCellHeight() -> CGFloat {
        guard let frame = cellTopView?.frame else {
            return 0
        }
        return frame.size.height
    }
    
    func getCellWidth() -> CGFloat {
        guard let frame = cellTopView?.frame else {
            return 0
        }
        return frame.size.width
    }
}
