//
//  ImageCouponModel.swift
//  CouponApp
//
//  Created by 벨소프트 on 2018. 1. 15..
//  Copyright © 2018년 kim sunchul. All rights reserved.
//

import Foundation
import FMDB

/// 쿠폰 이미지 UI 데이터
final class ImageCoupon: Codable, MerchantType, CouponUIType {

  // MARK: - Define

  private enum ImageCouponKeys: String, CodingKey {
    case couponId = "coupon_id"
    case merchantID = "merchant_id"
    case isEvent = "isEvent"
    case normalImage = "normal_image"
    case selectImage = "select_image"
  }

  // MARK: - CouponUI Property

  /// 쿠폰 인덱스
  var couponId: Int
  /// 이벤트 여부
  var isEvent: Bool
  /// 쿠폰 사용 여부
  var isUseCoupon: Bool
  /// 애니메이션 사용여부
  var isAnimation: Bool

  // MARK: - Merchant Property

  /// 가맹점 ID
  var merchantID: Int

  // MARK: - Property

  /// 평소 이미지
  let normalImage: String
  /// 선택된 이미지
  let selectImage: String

  // MARK: - Init

  init(couponId: Int,merchantID: Int,isEvent: Bool, normalImage: String, selectImage: String) {
    self.couponId = couponId
    self.merchantID = merchantID
    self.isEvent = isEvent
    self.normalImage = normalImage
    self.selectImage = selectImage
    self.isUseCoupon = false
    self.isAnimation = false
  }

  convenience init(resultSet: FMResultSet) {
    let merchantIDx: Int32 = resultSet.int(forColumnIndex: 0)
    let couponIdx: Int32 = resultSet.int(forColumnIndex: 1)
    let normalImage: String = resultSet.string(forColumnIndex: 2) ?? ""
    let selectImage: String = resultSet.string(forColumnIndex: 3) ?? ""
    let isEvent: Bool = resultSet.bool(forColumnIndex: 4)

    self.init(
      couponId: Int(couponIdx),
      merchantID: Int(merchantIDx),
      isEvent: isEvent,
      normalImage: normalImage,
      selectImage: selectImage
    )
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: ImageCouponKeys.self)
    self.couponId = try container.decode(Int.self, forKey: .couponId)
    self.merchantID = try container.decode(Int.self, forKey: .merchantID)
    self.isEvent = try container.decode(Bool.self, forKey: .isEvent)
    self.normalImage = try container.decode(String.self, forKey: .normalImage)
    self.selectImage = try container.decode(String.self, forKey: .selectImage)
    self.isUseCoupon = false
    self.isAnimation = false
  }
}
