//
//  CustomPopupOutputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/10.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol CustomPopupOutputType: OutputType {
  var callback: Observable<CustomPopup> { get }
  var showAnimation: Observable<Void> { get }
  var close: Observable<Void> { get }
  var title: Observable<String> { get }
  var content: Observable<String> { get }
  var popupViewAlpha: Observable<CGFloat> { get }
}


struct CustomPopupOutputs: CustomPopupOutputType {
  let content: Observable<String>
  let callback: Observable<CustomPopup>
  let showAnimation: Observable<Void>
  let close: Observable<Void>
  let title: Observable<String>
  let popupViewAlpha: Observable<CGFloat>
}
