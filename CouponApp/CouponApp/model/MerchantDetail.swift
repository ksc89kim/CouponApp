//
//  MerchantInfoModel.swift
//  CouponApp
//
//  Created by kim sunchul on 06/05/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import UIKit

/// 가맹점 상세 데이터
struct MerchantDetail {

  /// 기존 헤더 높이
  var originalHeaderHeight: CGFloat = 0
  /// 애니메이션 시작점 Y
  var positionY: CGFloat = 0
  /// 가맹점 정보
  var merchant: MerchantImpl?

  // MARK: - 이전 셀에 대한 정보

  var cellTopLogoImage: UIImage?
  var cellFrame: CGRect?
  var cellBackgroundColor: UIColor?


  /// 셀 정보 세팅
  mutating func setCellData(cell: MerchantTableViewCell, offsetY: CGFloat) {
    self.merchant = cell.merchant
    self.cellFrame = cell.topView.frame
    self.cellBackgroundColor = cell.topView.backgroundColor
    self.cellTopLogoImage = cell.logoImageView.image
    self.positionY = cell.frame.origin.y - offsetY + cell.headerTopHeight
  }

  /// 셀 높이
  func getCellHeight() -> CGFloat {
    guard let frame = self.cellFrame else {
      return 0
    }
    return frame.size.height
  }

  /// 셀 넓이
  func getCellWidth() -> CGFloat {
    guard let frame = self.cellFrame else {
      return 0
    }
    return frame.size.width
  }

  /// 셀 이미지
  func getCellImage() -> UIImage {
    guard let image = self.cellTopLogoImage else {
      return UIImage()
    }
    return image
  }
}
