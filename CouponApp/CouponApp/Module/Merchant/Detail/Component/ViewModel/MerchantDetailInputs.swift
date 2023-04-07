//
//  MerchantDetailInputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/10.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MerchantDetailInputType: InputType {
  /// 가맹점 상세 정보
  var merchantDetail: AnyObserver<MerchantDetail?> { get }
  /// 하단 버튼 액션 (추가하기/삭제하기)
  var actionFromBottom: AnyObserver<Void> { get }
}


struct MerchantDetailInputs: MerchantDetailInputType {
  let merchantDetail: AnyObserver<MerchantDetail?>
  let actionFromBottom: AnyObserver<Void>
}
