//
//  ViewModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/10/25.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import RxSwift
import UIKit

protocol ViewModel {
  associatedtype Action
  associatedtype State

  var action: Action { get }
  var state: State { get }
}
