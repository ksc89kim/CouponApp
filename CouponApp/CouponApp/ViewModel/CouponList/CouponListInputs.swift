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
  var loadCoupon: AnyObserver<CouponInfo> { get }
  var onAddCoupon: AnyObserver<Void> { get }
  var onUseCoupon: AnyObserver<Void> { get }
}


struct CouponListInputs: CouponListInputType {
  let loadCoupon: AnyObserver<CouponInfo>
  let onAddCoupon: AnyObserver<Void>
  let onUseCoupon: AnyObserver<Void>
}
