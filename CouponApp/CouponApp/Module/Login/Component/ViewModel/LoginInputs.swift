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
  /// 가입하기
  var onSingup: AnyObserver<Void> { get }
  /// 로그인하기
  var onLogin: AnyObserver<Void> { get }
  /// 유저 전화번호
  var userPhoneNumber: AnyObserver<String?> { get }
  /// 유저 비밀번호
  var userPassword: AnyObserver<String?> { get }
}


struct LoginInputs: LoginInputType {
  let onSingup: AnyObserver<Void>
  let onLogin: AnyObserver<Void>
  let userPhoneNumber: AnyObserver<String?>
  let userPassword: AnyObserver<String?>
}
