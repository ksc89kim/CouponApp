//
//  IntroInputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/06.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol IntroInputType: InputType {
  var loadMerchantData: AnyObserver<Void> { get }
}


struct IntroInputs: IntroInputType {
  let loadMerchantData: AnyObserver<Void>
}
