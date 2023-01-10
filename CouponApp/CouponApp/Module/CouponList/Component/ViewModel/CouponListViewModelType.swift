//
//  CouponListViewModelType.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/09.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation

protocol CouponListViewModelType: ViewModelType {
  var inputs: CouponListInputType { get }
  var outputs: CouponListOutputType? { get }
}


extension CouponListViewModelType  {
  var baseInputs: InputType {
    return self.inputs
  }

  var baseOutputs: OutputType? {
    return self.outputs
  }
}
