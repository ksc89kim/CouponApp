//
//  UserMerchantOutputs.swift
//  CouponApp
//
//  Created by kim sunchul on 2021/08/11.
//  Copyright © 2021 kim sunchul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol UserMerchantOutputType: OutputType {
  /// 쿠폰 테이블 화면 업데이트
  var reloadSections: Observable<[UserMerchantSection]> { get }
  /// 삭제된 쿠폰  테이블 업데이트
  var updateCouponToDelete: Observable<([UserMerchantSection], IndexPath)> { get }
  /// 알럿 팝업 보여주기
  var showCustomPopup: Observable<CustomPopup> { get }
  /// 유저 쿠폰 리스트 보여주기
  var showCouponListViewController: Observable<CouponInfo> { get }
}


struct UserMerchantOutputs: UserMerchantOutputType {
  let reloadSections: Observable<[UserMerchantSection]>
  let updateCouponToDelete: Observable<([UserMerchantSection], IndexPath)>
  let showCustomPopup: Observable<CustomPopup>
  let showCouponListViewController: Observable<CouponInfo>
}
