//
//  CouponListOutputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/09.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CouponListOutputType: OutputType {
  /// 네비게이션 제목
  var navigationTitle: Observable<String> { get }
  /// 커스텀 팝업 보여주기
  var showCustomPopup: Observable<CustomPopupConfigurable> { get }
  /// 쿠폰 리스트 리로드
  var reloadSections: Observable<[CouponSection]> { get }
}


struct CouponListOutputs: CouponListOutputType {
  let navigationTitle: Observable<String>
  let showCustomPopup: Observable<CustomPopupConfigurable>
  let reloadSections: Observable<[CouponSection]>
}
