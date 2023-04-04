//
//  UserMerchantOutputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/11.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserMerchantOutputType: OutputType {
  var reload: Observable<UserCouponList> { get }
  var delete: Observable<IndexPath> { get }
  var showCustomPopup: Observable<CustomPopup> { get }
}


struct UserMerchantOutputs: UserMerchantOutputType {
  let reload: Observable<UserCouponList>
  let delete: Observable<IndexPath>
  let showCustomPopup: Observable<CustomPopup>
}
