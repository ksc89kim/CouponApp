//
//  UserMerchantInputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/11.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserMerchantInputType: InputType {
  /// 가맹점 정보
  var merchantList: AnyObserver<(any MerchantListable)?> { get }
  /// 유저 가맹점 데이터 요청
  var loadData: AnyObserver<Void> { get }
  /// 유저 쿠폰 리스트 뷰컨트롤러 이동
  var showCouponListViewController: AnyObserver<MerchantType> { get }
  /// 유저 쿠폰 삭제 요청
  var deleteCoupon: AnyObserver<IndexPath> { get }
}


struct UserMerchantInputs: UserMerchantInputType {
  let merchantList: AnyObserver<(any MerchantListable)?>
  let loadData: AnyObserver<Void>
  let showCouponListViewController: AnyObserver<MerchantType>
  let deleteCoupon: AnyObserver<IndexPath>
}
