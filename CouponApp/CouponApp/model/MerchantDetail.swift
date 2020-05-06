//
//  MerchantInfoModel.swift
//  CouponApp
//
//  Created by kim sunchul on 06/05/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import UIKit

/*
 가맹점 상세 데이터
 */

struct MerchantDetail {
    var originalHeaderHeight:CGFloat = 0     //기존 헤더 높이
    var merchant:MerchantImpl? // 가맹점 정보
    var isUserCoupon:Bool = false // 사용자 쿠폰 여부
    var positionY:CGFloat = 0// 애니메이션 시작점 Y
    
    // 이전 셀에 대한 정보
    weak var cellTopView:UIView?
    weak var cellTopLogoImage:UIImage?
    
    // 폰트 관련 정보
    var titleFontSize:CGFloat = 30
    var cellFontSize:CGFloat = 17
    
    mutating func setCellData(cell:MerchantTableViewCell, offsetY:CGFloat) {
        self.merchant = cell.merchant
        self.cellTopView = cell.topView
        self.cellTopLogoImage = cell.logoImageView.image ?? UIImage()
        self.positionY = cell.frame.origin.y - offsetY + cell.headerTopHeight
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
