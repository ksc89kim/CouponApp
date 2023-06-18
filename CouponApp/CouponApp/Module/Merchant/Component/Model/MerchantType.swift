//
//  MerchantProtocol.swift
//  CouponApp
//
//  Created by kim sunchul on 2018. 8. 7..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation
import CoreLocation
import FMDB

enum MerchantKey: InjectionKey {
  typealias Value = MerchantType
}

/// 가맹점 데이터
protocol MerchantType: Injectable {
  /// 가맹점 ID
  var merchantID: Int { get set }
  /// 가맹점 이름
  var name: String { get set }
  /// 가맹점 소개 내용
  var content: String { get set }
  /// 로고 이미지 url
  var logoImageUrl: URL? { get set }
  /// 쿠폰 갯수
  var couponCount: Int { get }
  /// 위치 정보
  var location: CLLocation { get }
  /// 카드 백그라운드
  var cardBackGround: String { get set }
  /// 쿠폰 이미지 여부
  var isCouponImage: Bool { get set}
  /// 쿠폰 이미지 데이터
  var imageCouponList: [ImageCoupon] { get set }
  /// 쿠폰 그리기 데이터
  var drawCouponList: [DrawCoupon] { get set }
  /// FMDB 데이터 설정
  mutating func setResult(resultSet: FMResultSet)
  /// 쿠폰 정보
  func index(_ index:Int) -> CouponUIType
}
