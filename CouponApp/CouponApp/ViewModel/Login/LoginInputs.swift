//
//  LoginInputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/09.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginInputType: InputType {
  var onSingup: AnyObserver<Void> { get }
  var onLogin: AnyObserver<Void> { get }
  var userPhoneNumber: AnyObserver<String?> { get }
  var userPassword: AnyObserver<String?> { get }
}


struct LoginInputs: LoginInputType {
  let onSingup: AnyObserver<Void>
  let onLogin: AnyObserver<Void>
  let userPhoneNumber: AnyObserver<String?>
  let userPassword: AnyObserver<String?>
}
