//
//  MerchantListInputs.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/02/03.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MerchantListInputType: InputType {
  /// 가맹점 선택
  var selecItem: AnyObserver<MerchantSelect> { get }
  /// 전체 가맹점 정보
  var merchantList: AnyObserver<MerchantList?> { get }
}


struct MerchantListInputs: MerchantListInputType {
  let selecItem: AnyObserver<MerchantSelect>
  let merchantList: AnyObserver<MerchantList?>
}
