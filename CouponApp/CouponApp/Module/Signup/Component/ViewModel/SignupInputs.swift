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
  /// 가입하기
  var onSingup: AnyObserver<Void> { get }
  /// 유저 이름
  var userName: AnyObserver<String?> { get }
  /// 유저 전화번호
  var userPhoneNumber: AnyObserver<String?> { get }
  /// 유저 비밀번호
  var userPassword: AnyObserver<String?> { get }
}


struct SignupInputs: SignupInputType {
  let onSingup: AnyObserver<Void>
  let userName: AnyObserver<String?>
  let userPhoneNumber: AnyObserver<String?>
  let userPassword: AnyObserver<String?>
}
