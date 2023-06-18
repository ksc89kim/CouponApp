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
  /// 기존 셀  Radius
  let cellCornerRadius: CGFloat
  /// 기존 셀 상단 프레임
  let cellTopViewFrame: CGRect
  /// 가맹점 정보
  let merchant: MerchantType
}
