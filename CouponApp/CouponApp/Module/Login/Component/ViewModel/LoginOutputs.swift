//
//  LoginOutputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/09.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginOutputType: OutputType {
  /// 커스텀 알럿 보여주기
  var showCustomPopup: Observable<CustomPopup> { get }
  /// 메인 뷰 컨트롤러 보여주기
  var showMainViewController: Observable<Void> { get }
  /// 가입화면 뷰컨트롤러 보여주기
  var showSignupViewController: Observable<Void> { get }
}


struct LoginOutputs: LoginOutputType {
  let showCustomPopup: Observable<CustomPopup>
  let showMainViewController: Observable<Void>
  let showSignupViewController: Observable<Void>
}
