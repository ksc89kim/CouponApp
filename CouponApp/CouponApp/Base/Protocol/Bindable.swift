//
//  BaseBind.swift
//  CouponApp
//
//  Created by kim sunchul on 2020/12/20.
//  Copyright © 2020 kim sunchul. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol Bindable {
  var disposeBag: DisposeBag { get }
  func bind()
  func bindInputs()
  func bindOutputs()
}


extension Bindable {
  func bind() {
    self.bindOutputs()
    self.bindInputs()
  }
}
