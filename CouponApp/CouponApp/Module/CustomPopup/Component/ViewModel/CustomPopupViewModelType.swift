//
//  CustomPopupViewModelType.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/10.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation

enum CustomPopupViewModelKey: InjectionKey {
  typealias Value = CustomPopupViewModelType
}


protocol CustomPopupViewModelType: ViewModelType, Injectable {
  var inputs: CustomPopupInputType { get }
  var outputs: CustomPopupOutputType? { get }
}


extension CustomPopupViewModelType  {
  var baseInputs: InputType {
    return self.inputs
  }

  var baseOutputs: OutputType? {
    return self.outputs
  }
}
