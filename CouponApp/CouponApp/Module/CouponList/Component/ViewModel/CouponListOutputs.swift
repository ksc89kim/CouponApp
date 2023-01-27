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
  var showCustomPopup: Observable<CustomPopup> { get }
  var reloadSections: Observable<[CouponSection]> { get }
}


struct CouponListOutputs: CouponListOutputType {
  let navigationTitle: Observable<String>
  let showCustomPopup: Observable<CustomPopup>
  let reloadSections: Observable<[CouponSection]>
}
