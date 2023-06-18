//
//  Merchant.swift
//  CouponApp
//
//  Created by kim sunchul on 2017. 12. 6..
//  Copyright © 2017년 kim sunchul. All rights reserved.
//

import Foundation
import CoreLocation
import FMDB

struct Merchant: Codable, MerchantType {

  //MARK: - Define

  private enum Keys: String, CodingKey {
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

  var merchantID: Int
  var name: String
  var content: String
  var logoImageUrl: URL?
  /// 위도
  private var latitude: Double
  /// 경도
  private var longitude: Double
  var isCouponImage: Bool
  var imageCouponList: [ImageCoupon]
  var drawCouponList: [DrawCoupon]
  var cardBackGround: String = "000000"
  var couponCount: Int {
    return self.isCouponImage ? self.imageCouponList.count : self.drawCouponList.count
  }
  var location: CLLocation {
    return .init(
      latitude: self.latitude,
      longitude: self.longitude
    )
  }

  //MARK: - Init

  init() {
    self.merchantID = -1
    self.name = ""
    self.content = ""
    self.logoImageUrl = nil
    self.latitude = 0
    self.longitude = 0
    self.isCouponImage = false
    self.imageCouponList = []
    self.drawCouponList = []
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Keys.self)
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

  mutating func setResult(resultSet: FMResultSet) {
    let merchantID: Int32 = resultSet.int(forColumnIndex: 0)
    let name = resultSet.string(forColumnIndex: 1) ?? ""
    let content = resultSet.string(forColumnIndex: 2) ?? ""
    let imageUrl = resultSet.string(forColumnIndex: 3) ?? ""
    let latitude = resultSet.double(forColumnIndex: 4)
    let longitude = resultSet.double(forColumnIndex: 5)
    let isCouponImage = resultSet.bool(forColumnIndex: 6)
    let cardBackground = resultSet.string(forColumnIndex: 7) ?? ""

    self.merchantID = Int(merchantID)
    self.name = name
    self.content = content
    self.logoImageUrl = URL(string: imageUrl)
    self.latitude = latitude
    self.longitude = longitude
    self.isCouponImage = isCouponImage
    self.imageCouponList = []
    self.drawCouponList = []
    self.cardBackGround = cardBackground
  }
}
