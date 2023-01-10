//
//  SignupViewModelType.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/06.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation

protocol SignupViewModelType: ViewModelType {
  var inputs: SignupInputType { get }
  var outputs: SignupOutputType? { get }
}


extension SignupViewModelType  {
  var baseInputs: InputType {
    return self.inputs
  }

  var baseOutputs: OutputType? {
    return self.outputs
  }
}
