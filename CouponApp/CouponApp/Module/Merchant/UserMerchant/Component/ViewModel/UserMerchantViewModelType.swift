//
//  UserMerchantViewModelType.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/11.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserMerchantViewModelType: ViewModelType {
  var inputs: UserMerchantInputType { get }
  var outputs: UserMerchantOutputType? { get }
}


extension UserMerchantViewModelType  {
  var baseInputs: InputType {
    return self.inputs
  }

  var baseOutputs: OutputType? {
    return self.outputs
  }
}
