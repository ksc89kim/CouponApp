//
//  MerchantDetailOutputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/10.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MerchantDetailOutputType: OutputType {
  var cellTopViewFrame: Observable<CGRect> { get }
  var cellCornerRadius: Observable<CGFloat> { get }
  var title: Observable<String> { get }
  var buttonTitle: Observable<String> { get }
  var introduce: Observable<String> { get }
  var headerBackgroundColor: Observable<UIColor?> { get }
  var headerImageURL: Observable<URL?> { get }
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
