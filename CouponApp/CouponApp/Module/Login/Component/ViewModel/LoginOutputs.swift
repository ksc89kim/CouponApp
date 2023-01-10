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
  var showCustomPopup: Observable<CustomPopup> { get }
  var showMainViewController: Observable<Void> { get }
  var savePhoneNumber: Observable<String> { get }
  var showSignupViewController: Observable<Void> { get }
}


struct LoginOutputs: LoginOutputType {
  let showCustomPopup: Observable<CustomPopup>
  let showMainViewController: Observable<Void>
  let savePhoneNumber: Observable<String>
  let showSignupViewController: Observable<Void>
}
