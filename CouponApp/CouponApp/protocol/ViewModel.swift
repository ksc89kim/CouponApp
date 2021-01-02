//
//  ViewModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/10/25.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import UIKit

protocol ViewModel {
  associatedtype Inputs
  associatedtype Outputs
  associatedtype BindInputs
  
  var inputs: Inputs { get }
  var outputs: Outputs { get }
  func bind(inputs: BindInputs)
}
