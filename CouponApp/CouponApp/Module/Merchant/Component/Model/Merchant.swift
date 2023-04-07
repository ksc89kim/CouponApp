//
//  Merchant.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 12. 6..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import Foundation

/// 가맹점 데이터
struct Merchant: Codable, MerchantType {

  //MARK: - Define

  private enum MerchantImplKeys: String, CodingKey {
    case merchantID = "id"
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
  var merchantID: Int
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
    merchantID: Int,
    name: String,
    content: String,
    logoImageUrl: String,
    latitude: Double,
    longitude: Double,
    isCouponImage: Bool,
    cardBackground: String
  ) {
    self.merchantID = merchantID
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

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: MerchantImplKeys.self)
    self.merchantID = try container.decode(Int.self, forKey: .merchantID)
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

  func index(_ index:Int) -> CouponUIType {
    return self.isCouponImage ? self.imageCouponList[index] : self.drawCouponList[index]
  }

  func couponCount() -> Int {
    return self.isCouponImage ? self.imageCouponList.count : self.drawCouponList.count
  }
}
