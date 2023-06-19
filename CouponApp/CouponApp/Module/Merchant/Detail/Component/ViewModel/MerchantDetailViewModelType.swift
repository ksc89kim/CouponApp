//
//  MerchantDetailViewModelType.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/10.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation

enum MerchantDetailViewModelKey: InjectionKey {
  typealias Value = MerchantDetailViewModelType
}


protocol MerchantDetailViewModelType: ViewModelType, Injectable {
  var inputs: MerchantDetailInputType { get }
  var outputs: MerchantDetailOutputType? { get }
}


extension MerchantDetailViewModelType  {
  var baseInputs: InputType {
    return self.inputs
  }

  var baseOutputs: OutputType? {
    return self.outputs
  }
}
