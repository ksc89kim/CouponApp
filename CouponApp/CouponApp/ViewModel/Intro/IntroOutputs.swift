//
//  IntroOutputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/06.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol IntroOutputType: OutputType {
  var addLoginViewController: Observable<Void> { get }
  var addMainViewController: Observable<Void> { get }
}


struct IntroOutputs: IntroOutputType {
  let addLoginViewController: Observable<Void>
  let addMainViewController: Observable<Void>
}
