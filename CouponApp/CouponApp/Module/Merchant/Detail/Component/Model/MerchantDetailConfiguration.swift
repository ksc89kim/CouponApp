//
//  MerchantDetailConfiguration.swift
//  CouponApp
//
//  Created by kim sunchul on 06/05/2019.
//  Copyright © 2019 kim sunchul. All rights reserved.
//

import UIKit

enum MerchantDetailConfigurationKey: InjectionKey {
  typealias Value = MerchantDetailConfigurable
}


/// 가맹점 상세 데이터
protocol MerchantDetailConfigurable: Injectable {
  /// 기존 셀  Radius
  var cellCornerRadius: CGFloat { get set }
  /// 기존 셀 상단 프레임
  var cellTopViewFrame: CGRect { get set }
  /// 가맹점 정보
  var merchant: MerchantType? { get set }
  // 가맹점 ID
  var merchantID: Int { get }
}


struct MerchantDetailConfiguration: MerchantDetailConfigurable  {

  // MARK: - Property

  var cellCornerRadius: CGFloat
  var cellTopViewFrame: CGRect
  var merchant: MerchantType?
  var merchantID: Int {
    return self.merchant?.merchantID ?? 0
  }

  // MARK: - Init

  init() {
    self.cellCornerRadius = .zero
    self.cellTopViewFrame = .zero
    self.merchant = nil
  }
}
