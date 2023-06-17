//
//  CouponListInputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/09.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CouponListInputType: InputType {
  /// 쿠폰 정보 요청
  var loadCoupon: AnyObserver<CouponInfoType?> { get }
  /// 쿠폰 추가
  var onAddCoupon: AnyObserver<Void> { get }
  /// 쿠폰 사용
  var onUseCoupon: AnyObserver<Void> { get }
}


struct CouponListInputs: CouponListInputType {
  let loadCoupon: AnyObserver<CouponInfoType?>
  let onAddCoupon: AnyObserver<Void>
  let onUseCoupon: AnyObserver<Void>
}
