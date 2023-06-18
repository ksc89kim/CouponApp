//
//  IntroViewModelType.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/06.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum IntroViewModelKey: InjectionKey {
  typealias Value = IntroViewModelType
}


protocol IntroViewModelType: ViewModelType, Injectable {
  var inputs: IntroInputType { get }
  var outputs: IntroOutputType? { get }
}


extension IntroViewModelType  {
  var baseInputs: InputType {
    return self.inputs
  }

  var baseOutputs: OutputType? {
    return self.outputs
  }
}
