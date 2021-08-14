//
//  LoginViewModelType.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/09.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation

protocol LoginViewModelType: ViewModelType {
  var inputs: LoginInputType { get }
  var outputs: LoginOutputType? { get }
}


extension LoginViewModelType  {
  var baseInputs: InputType {
    return self.inputs
  }

  var baseOutputs: OutputType? {
    return self.outputs
  }
}
