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
  var loadData: AnyObserver<Void> { get }
  var deleteCoupon: AnyObserver<(merchantId: Int, indexPath: IndexPath)> { get }
}


struct UserMerchantInputs: UserMerchantInputType {
  let loadData: AnyObserver<Void>
  let deleteCoupon: AnyObserver<(merchantId: Int, indexPath: IndexPath)>
}
