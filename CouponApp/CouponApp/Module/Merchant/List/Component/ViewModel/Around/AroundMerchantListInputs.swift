//
//  AroundMerchantListInputs.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/02/06.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

struct AroundMerchantListInputs: MerchantListInputType {
  let selecItem: AnyObserver<MerchantSelect>
  let merchantList: AnyObserver<(any MerchantListable)?>
  /// 업데이트 된 지역 정보
  let didUpdateLocation: AnyObserver<CLLocationManager>
}
