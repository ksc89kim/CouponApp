//
//  CustomPopupOutputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/10.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol CustomPopupOutputType: OutputType {
  var showAnimation: Observable<Void> { get }
  var close: Observable<CustomPopup> { get }
  var title: Observable<String> { get }
  var content: Observable<String> { get }
  var popupViewAlpha: Observable<CGFloat> { get }
}


struct CustomPopupOutputs: CustomPopupOutputType {
  let content: Observable<String>
  let showAnimation: Observable<Void>
  let close: Observable<CustomPopup>
  let title: Observable<String>
  let popupViewAlpha: Observable<CGFloat>
}
