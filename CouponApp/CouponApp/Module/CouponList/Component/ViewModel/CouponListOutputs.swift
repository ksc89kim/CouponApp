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
  var navigationTitle: Observable<String> { get }
  var reload: Observable<Void> { get }
  var showCustomPopup: Observable<CustomPopup> { get }
  var selectedCouponIndex: Observable<Int> { get }
}


struct CouponListOutputs: CouponListOutputType {
  let navigationTitle: Observable<String>
  let reload: Observable<Void>
  let showCustomPopup: Observable<CustomPopup>
  let selectedCouponIndex: Observable<Int>
}
