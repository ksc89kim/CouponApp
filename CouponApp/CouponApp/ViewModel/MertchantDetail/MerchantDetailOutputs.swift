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
  var title: Observable<String> { get }
  var buttonTitle: Observable<String> { get }
  var introduce: Observable<String> { get }
  var headerBackgroundColor: Observable<UIColor?> { get }
  var headerImage: Observable<UIImage> { get }
  var showCustomPopup: Observable<CustomPopup> { get }
}


struct MerchantDetailOutputs: MerchantDetailOutputType {
  var title: Observable<String>
  var buttonTitle: Observable<String>
  var introduce: Observable<String>
  var headerBackgroundColor: Observable<UIColor?>
  var headerImage: Observable<UIImage>
  var showCustomPopup: Observable<CustomPopup>
}
