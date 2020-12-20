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

protocol BaseBind {

  var disposeBag: DisposeBag { get }

  func bind()
  func bindInputs()
  func bindOutpus()
}

extension BaseBind {

  func bind() {
    self.bindOutpus()
    self.bindInputs()
  }

}
