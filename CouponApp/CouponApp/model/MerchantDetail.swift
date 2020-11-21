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
    var originalHeaderHeight: CGFloat = 0     //기존 헤더 높이
    var isUserCoupon: Bool = false // 사용자 쿠폰 여부
    var positionY: CGFloat = 0// 애니메이션 시작점 Y
    var merchant: MerchantImpl? // 가맹점 정보

    // 이전 셀에 대한 정보
    var cellTopLogoImage: UIImage?
    var cellFrame: CGRect?
    var cellBackgroundColor: UIColor?
    let cellFontSize: CGFloat = 17

    // 폰트 관련 정보
    let titleFontSize: CGFloat = 30
    
    mutating func setCellData(cell:MerchantTableViewCell, offsetY:CGFloat) {
        self.merchant = cell.merchant
        self.cellFrame = cell.topView.frame
        self.cellBackgroundColor = cell.topView.backgroundColor
        self.cellTopLogoImage = cell.logoImageView.image
        self.positionY = cell.frame.origin.y - offsetY + cell.headerTopHeight
    }
    
    func getCellHeight() -> CGFloat {
        guard let frame = self.cellFrame else {
            return 0
        }
        return frame.size.height
    }
    
    func getCellWidth() -> CGFloat {
        guard let frame = self.cellFrame else {
            return 0
        }
        return frame.size.width
    }
    
    func getCellImage() -> UIImage {
        guard let image = cellTopLogoImage else {
            return UIImage()
        }
        return image
    }
}
