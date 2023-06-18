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
  /// 화면 나타날때 보여주는 FadeIn 애니메이션
  var showAnimation: Observable<Void> { get }
  /// 팝업 닫기
  var close: Observable<CustomPopupConfigurable> { get }
  /// 팝업 제목
  var title: Observable<String> { get }
  /// 팝업 내용
  var content: Observable<String> { get }
  /// 팝업 뷰 투명도
  var popupViewAlpha: Observable<CGFloat> { get }
}


struct CustomPopupOutputs: CustomPopupOutputType {
  let content: Observable<String>
  let showAnimation: Observable<Void>
  let close: Observable<CustomPopupConfigurable>
  let title: Observable<String>
  let popupViewAlpha: Observable<CGFloat>
}
