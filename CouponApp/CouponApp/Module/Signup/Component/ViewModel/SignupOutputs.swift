//
//  SignupOutputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/06.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignupOutputType: OutputType {
  /// 커스텀 팝업 보여주기
  var showCustomPopup: Observable<CustomPopup> { get }
  /// 메인 뷰 컨트롤러 보여주기
  var showMainViewController: Observable<Void> { get }
}


struct SignupOutputs: SignupOutputType {
  let showCustomPopup: Observable<CustomPopup>
  let showMainViewController: Observable<Void>
}
