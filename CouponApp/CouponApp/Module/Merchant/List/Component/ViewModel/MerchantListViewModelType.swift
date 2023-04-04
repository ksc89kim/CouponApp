//
//  MerchantListViewModelType.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/02/03.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation

protocol MerchantListViewModelType: ViewModelType {
  var inputs: MerchantListInputType { get }
  var outputs: MerchantListOutputType? { get }
}


extension MerchantListViewModelType  {
  var baseInputs: InputType {
    return self.inputs
  }

  var baseOutputs: OutputType? {
    return self.outputs
  }
}
