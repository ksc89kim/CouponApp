//
//  MerchantDetailInputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/10.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MerchantDetailInputType: InputType {
  var loadData: AnyObserver<MerchantDetail> { get }
  var actionFromBottom: AnyObserver<Void> { get }
}


struct MerchantDetailInputs: MerchantDetailInputType {
  let loadData: AnyObserver<MerchantDetail>
  let actionFromBottom: AnyObserver<Void>
}
