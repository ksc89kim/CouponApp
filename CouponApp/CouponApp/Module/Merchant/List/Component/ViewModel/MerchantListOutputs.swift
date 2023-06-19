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
  /// 주변 가맹점 테이블뷰 리로드
  var reloadSections: Observable<[MerchantListSection]> { get }
  /// 가맹점 상세로 이동
  var presentDetail: Observable<MerchantDetailConfigurable> { get }
}


struct MerchantListOutputs: MerchantListOutputType {
  let reloadSections: Observable<[MerchantListSection]>
  let presentDetail: Observable<MerchantDetailConfigurable>
}
