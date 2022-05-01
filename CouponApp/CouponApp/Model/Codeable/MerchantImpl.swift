//
//  MerchantModel.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 12. 6..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import Foundation
import FMDB

/// 가맹점 데이터
final class MerchantImpl: Codable, Merchant {

  //MARK: - Define

  private enum MerchantImplKeys: String, CodingKey {
    case merchantId = "id"
    case name
    case content
    case logoImageUrl = "imageUrl"
    case latitude
    case longitude
    case isCouponImage
    case imageCouponList
    case drawCouponList
  }

  //MARK: - Property

  /// 가맹점 ID
  var merchantId: Int
  /// 가맹점 이름
  let name: String
  /// 가맹점 소개 내용
  let content: String
  /// 로고 이미지 url
  let logoImageUrl: URL?
  /// 위도
  let latitude: Double
  /// 경도
  let longitude: Double
  /// 쿠폰 이미지 여부
  let isCouponImage: Bool
  /// 쿠폰 이미지 데이터
  var imageCouponList: [ImageCoupon]
  /// 쿠폰 그리기 데이터
  var drawCouponList: [DrawCoupon]
  /// 카드 백그라운드
  var cardBackGround: String = "000000"

  //MARK: - Init

  init(
    merchantId: Int,
    name: String,
    content: String,
    logoImageUrl: String,
    latitude: Double,
    longitude: Double,
    isCouponImage: Bool,
    cardBackground: String
  ) {
    self.merchantId = merchantId
    self.name = name
    self.content = content
    self.logoImageUrl = URL(string: logoImageUrl) 
    self.latitude = latitude
    self.longitude = longitude
    self.isCouponImage = isCouponImage
    self.imageCouponList = []
    self.drawCouponList = []
    self.cardBackGround = cardBackground
  }

  convenience init(resultSet: FMResultSet) {
    let merchantIdx:Int32 = resultSet.int(forColumnIndex: 0)
    let name = resultSet.string(forColumnIndex: 1) ?? ""
    let content = resultSet.string(forColumnIndex: 2) ?? ""
    let imageUrl = resultSet.string(forColumnIndex: 3) ?? ""
    let latitude = resultSet.double(forColumnIndex: 4)
    let longitude = resultSet.double(forColumnIndex: 5)
    let isCouponImage = resultSet.bool(forColumnIndex: 6)
    let cardBackground = resultSet.string(forColumnIndex: 7) ?? ""

    self.init(
      merchantId: Int(merchantIdx),
      name: name,
      content: content,
      logoImageUrl: imageUrl,
      latitude: latitude,
      longitude: longitude,
      isCouponImage: isCouponImage,
      cardBackground: cardBackground
    )
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MerchantImplKeys.self)
    self.merchantId = try container.decode(Int.self, forKey: .merchantId)
    self.name = try container.decode(String.self, forKey: .name)
    self.content = try container.decode(String.self, forKey: .content)
    self.logoImageUrl = try container.decode(URL.self, forKey: .logoImageUrl)
    self.latitude = try container.decode(Double.self, forKey: .latitude)
    self.longitude = try container.decode(Double.self, forKey: .longitude)
    self.isCouponImage = try container.decode(Bool.self, forKey: .isCouponImage)
    self.drawCouponList = (try? container.decode([DrawCoupon].self, forKey: .drawCouponList)) ?? []
    self.imageCouponList = (try? container.decode([ImageCoupon].self, forKey: .imageCouponList)) ?? []
  }

  //MARK: - Method

  func index(_ index:Int) -> CouponUI {
    return self.isCouponImage ? self.imageCouponList[index] : self.drawCouponList[index]
  }

  func couponCount() -> Int {
    return self.isCouponImage ? self.imageCouponList.count : self.drawCouponList.count
  }
}
