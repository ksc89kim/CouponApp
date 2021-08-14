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
  var configure: AnyObserver<CustomPopup?> { get }
  var onOk: AnyObserver<Void> { get }
  var viewDidLoad: AnyObserver<Void> { get }
}


struct CustomPopupInputs: CustomPopupInputType {
  let configure: AnyObserver<CustomPopup?>
  let onOk: AnyObserver<Void>
  let viewDidLoad: AnyObserver<Void>
}
