//
//  MerchantListOutputs.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/02/03.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MerchantListOutputType: OutputType {
  var reloadSections: Observable<[MerchantListSection]> { get }
  var presentDetail: Observable<MerchantDetail> { get }
}


struct MerchantListOutputs: MerchantListOutputType {
  let reloadSections: Observable<[MerchantListSection]>
  let presentDetail: Observable<MerchantDetail>
}
