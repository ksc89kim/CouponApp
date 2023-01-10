//
//  MerchantDetailInputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/10.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MerchantDetailInputType: InputType {
  var merchantDetail: AnyObserver<MerchantDetail?> { get }
  var actionFromBottom: AnyObserver<Void> { get }
  var headerViewSize: AnyObserver<CGSize> { get }
}


struct MerchantDetailInputs: MerchantDetailInputType {
  let merchantDetail: AnyObserver<MerchantDetail?>
  let actionFromBottom: AnyObserver<Void>
  let headerViewSize: AnyObserver<CGSize>
}
