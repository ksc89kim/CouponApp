//
//  DrawCouponModel.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 12..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import UIKit
import FMDB

/// 쿠폰 그리기 UI 데이터
final class DrawCoupon:Codable, Merchant, CouponUI {

  // MARK: - CouponUI

  /// 쿠폰 인덱스
  var couponId:Int
  /// 이벤트 여부
  var isEvent:Bool
  /// 쿠폰 사용 여부
  var isUseCoupon: Bool
  /// 애니메이션 사용 여부
  var isAnimation: Bool

  // MARK: - Merchant

  /// 가맹점 ID
  var merchantId: Int

  // MARK: - Draw

  /// 원 색상
  let circleColor: String
  /// 테두리 색상
  let ringColor: String
  /// 테두리 굵기
  let ringThickness: CGFloat
  /// 테두리 여부
  let isRing: Bool
  /// 쿠폰 체크박스 굵기
  let checkLineWidth: CGFloat
  /// 쿠폰 체크 박스 색상
  let checkLineColor: String

  private enum DrawCouponKeys: String, CodingKey {
    case couponId = "coupon_id"
    case merchantId = "merchant_id"
    case circleColor = "circle_color"
    case ringColor = "ring_color"
    case ringThickness = "ring_thickness"
    case isRing
    case checkLineWidth = "checkline_width"
    case checkLineColor = "checkline_color"
    case isEvent = "isEvent"
  }

  init(
    couponId: Int,
    merchantId: Int,
    circleColor: String,
    ringColor: String,
    ringThickness: CGFloat,
    isRing: Bool,
    checkLineWidth: CGFloat,
    checkLineColor: String,
    isEvent: Bool
  ) {
    self.couponId = couponId
    self.merchantId = merchantId
    self.circleColor = circleColor
    self.ringColor = ringColor
    self.ringThickness = ringThickness
    self.isRing = isRing
    self.checkLineColor = checkLineColor
    self.checkLineWidth = checkLineWidth
    self.isEvent = isEvent
    self.isUseCoupon = false
    self.isAnimation = false
  }

  convenience init(resultSet: FMResultSet) {
    let merchantIdx: Int32 = resultSet.int(forColumnIndex: 0)
    let couponIdx: Int32 = resultSet.int(forColumnIndex: 1)
    let circleColor: String =  resultSet.string(forColumnIndex: 2) ?? ""
    let ringColor: String = resultSet.string(forColumnIndex: 3) ?? ""
    let ringThickness: CGFloat = CGFloat(resultSet.double(forColumnIndex: 4))
    let isRing: Bool = resultSet.bool(forColumnIndex: 5)
    let checkLineWidth: CGFloat = CGFloat(resultSet.double(forColumnIndex: 6))
    let checkLineColor: String = resultSet.string(forColumnIndex: 7) ?? ""
    let isEvent: Bool = resultSet.bool(forColumnIndex: 8)

    self.init(
      couponId: Int(couponIdx),
      merchantId: Int(merchantIdx),
      circleColor: circleColor,
      ringColor: ringColor,
      ringThickness: ringThickness,
      isRing: isRing,
      checkLineWidth: checkLineWidth,
      checkLineColor: checkLineColor,
      isEvent: isEvent
    )
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: DrawCouponKeys.self)
    self.couponId = try container.decode(Int.self, forKey: .couponId)
    self.merchantId = try container.decode(Int.self, forKey: .merchantId)
    self.isEvent = try container.decode(Bool.self, forKey: .isEvent)
    self.isRing = try container.decode(Bool.self, forKey: .isRing)
    self.ringThickness = try container.decode(CGFloat.self, forKey: .ringThickness)
    self.checkLineWidth = try container.decode(CGFloat.self, forKey: .checkLineWidth)
    self.ringColor = try container.decode(String.self, forKey: .ringColor)
    self.circleColor = try container.decode(String.self, forKey: .circleColor)
    self.checkLineColor = try container.decode(String.self, forKey: .checkLineColor)
    self.isUseCoupon = false
    self.isAnimation = false
  }
}
