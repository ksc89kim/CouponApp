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
  var reloadSections: Observable<[UserMerchantSection]> { get }
  var updateCouponToDelete: Observable<([UserMerchantSection], IndexPath)> { get }
  var showCustomPopup: Observable<CustomPopup> { get }
  var showCouponListViewController: Observable<CouponInfo> { get }
}


struct UserMerchantOutputs: UserMerchantOutputType {
  let reloadSections: Observable<[UserMerchantSection]>
  let updateCouponToDelete: Observable<([UserMerchantSection], IndexPath)>
  let showCustomPopup: Observable<CustomPopup>
  let showCouponListViewController: Observable<CouponInfo>
}
