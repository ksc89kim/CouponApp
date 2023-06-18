//
//  CustomPopupInputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/10.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CustomPopupInputType: InputType {
  /// 커스텀 팝업 정보 설정
  var configure: AnyObserver<CustomPopupConfigurable?> { get }
  /// 커스텀 팝업 확인 버튼 액션
  var onOk: AnyObserver<Void> { get }
  /// 커스텀 팝업 보여주기
  var showPopup: AnyObserver<Void> { get }
}


struct CustomPopupInputs: CustomPopupInputType {
  let configure: AnyObserver<CustomPopupConfigurable?>
  let onOk: AnyObserver<Void>
  let showPopup: AnyObserver<Void>
}
