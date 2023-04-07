//
//  UserMerchantInputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/11.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserMerchantInputType: InputType {
  var merchantList: AnyObserver<MerchantList?> { get }
  var loadData: AnyObserver<Void> { get }
  var showCouponListViewController: AnyObserver<Merchant> { get }
  var deleteCoupon: AnyObserver<IndexPath> { get }
}


struct UserMerchantInputs: UserMerchantInputType {
  let merchantList: AnyObserver<MerchantList?>
  let loadData: AnyObserver<Void>
  let showCouponListViewController: AnyObserver<Merchant>
  let deleteCoupon: AnyObserver<IndexPath>
}
