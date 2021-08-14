//
//  SignupInputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/06.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignupInputType: InputType {
  var onSingup: AnyObserver<Void> { get }
  var userName: AnyObserver<String?> { get }
  var userPhoneNumber: AnyObserver<String?> { get }
  var userPassword: AnyObserver<String?> { get }
}


struct SignupInputs: SignupInputType {
  let onSingup: AnyObserver<Void>
  let userName: AnyObserver<String?>
  let userPhoneNumber: AnyObserver<String?>
  let userPassword: AnyObserver<String?>
}
