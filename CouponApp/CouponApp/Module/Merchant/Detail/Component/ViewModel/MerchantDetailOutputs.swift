//
//  MerchantDetailOutputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/10.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol MerchantDetailOutputType: OutputType {
  /// 가맹점 Cell 상단 UI Frame
  var cellTopViewFrame: Observable<CGRect> { get }
  /// 가맹점 Cell CornerRadius
  var cellCornerRadius: Observable<CGFloat> { get }
  /// 가맹점 제목
  var title: Observable<String> { get }
  /// 하단 버튼 이름
  var buttonTitle: Observable<String> { get }
  /// 가맹점 소개글
  var introduce: Observable<String> { get }
  /// 가맹점 상단 배경 색상
  var headerBackgroundColor: Observable<UIColor?> { get }
  /// 가맹점 Icon URL
  var headerImageURL: Observable<URL?> { get }
  /// 커스첨 알럿 보여주기
  var showCustomPopup: Observable<CustomPopup> { get }
}


struct MerchantDetailOutputs: MerchantDetailOutputType {
  let cellTopViewFrame: Observable<CGRect>
  let cellCornerRadius: Observable<CGFloat>
  let title: Observable<String>
  let buttonTitle: Observable<String>
  let introduce: Observable<String>
  let headerBackgroundColor: Observable<UIColor?>
  let headerImageURL: Observable<URL?>
  let showCustomPopup: Observable<CustomPopup>
}
