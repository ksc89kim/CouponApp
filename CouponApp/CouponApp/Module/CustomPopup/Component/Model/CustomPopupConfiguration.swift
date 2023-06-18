//
//  CustomPopupConfiguration.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/11/15.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift

enum CustomPopupConfigurationKey: InjectionKey {
  typealias Value = CustomPopupConfigurable
}


protocol CustomPopupConfigurable: Injectable {
  var title: String { get set }
  var message: String { get set }
  var completion: AnyObserver<Void>? { get set }
}


struct CustomPopupConfiguration: CustomPopupConfigurable {

  // MARK: - Property

  var title: String = ""
  var message: String = ""
  var completion: AnyObserver<Void>? = nil
}
