//
//  AroundMerchantListOutputs.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/02/24.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift

struct AroundMerchantListOutputs: MerchantListOutputType {
  let reloadSections: Observable<[MerchantListSection]>
  let presentDetail: Observable<MerchantDetailConfigurable>
}
