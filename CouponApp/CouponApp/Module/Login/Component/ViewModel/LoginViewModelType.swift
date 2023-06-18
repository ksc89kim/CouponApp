//
//  LoginViewModelType.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/09.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation

enum LoginViewModelKey: InjectionKey {
  typealias Value = LoginViewModelType
}


protocol LoginViewModelType: ViewModelType, Injectable {
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
