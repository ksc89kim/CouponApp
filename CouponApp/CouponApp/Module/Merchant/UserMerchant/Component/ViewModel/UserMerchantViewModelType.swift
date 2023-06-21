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

enum UserMerchantViewModelKey: InjectionKey {
  typealias Value = UserMerchantViewModelType
}


protocol UserMerchantViewModelType: ViewModelType, Injectable {
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
