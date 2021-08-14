//
//  ViewModelType.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/10/25.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import UIKit

protocol InputType {
}

protocol OutputType {
}

protocol ViewModelType {
  var baseInputs: InputType { get }
  var baseOutputs: OutputType? { get }
}
