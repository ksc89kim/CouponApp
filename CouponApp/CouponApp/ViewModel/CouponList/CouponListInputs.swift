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
  var viewDidLoad: AnyObserver<Void> { get }
  var onAddCoupon: AnyObserver<Void> { get }
  var onUseCoupon: AnyObserver<Void> { get }
  var userCoupon: AnyObserver<UserCoupon?> { get }
  var merchantCoupon: AnyObserver<MerchantImpl?> { get }
}


struct CouponListInputs: CouponListInputType {
  let viewDidLoad: AnyObserver<Void>
  let onAddCoupon: AnyObserver<Void>
  let onUseCoupon: AnyObserver<Void>
  let userCoupon: AnyObserver<UserCoupon?>
  let merchantCoupon: AnyObserver<MerchantImpl?>
}
