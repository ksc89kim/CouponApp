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
  /// 로그인 뷰컨트롤러 자식 뷰 컨트롤러로 추가
  var addLoginViewController: Observable<MerchantList> { get }
  /// 메인 뷰컨트롤러 자식 뷰 컨트롤러로 추가
  var addMainViewController: Observable<MerchantList> { get }
}


struct IntroOutputs: IntroOutputType {
  let addLoginViewController: Observable<MerchantList>
  let addMainViewController: Observable<MerchantList>
}
