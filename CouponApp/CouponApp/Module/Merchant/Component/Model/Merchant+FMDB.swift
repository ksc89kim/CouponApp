//
//  Merchant+FMDB.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/01/06.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation
import FMDB

extension Merchant {
  init(resultSet: FMResultSet) {
    let merchantIDx:Int32 = resultSet.int(forColumnIndex: 0)
    let name = resultSet.string(forColumnIndex: 1) ?? ""
    let content = resultSet.string(forColumnIndex: 2) ?? ""
    let imageUrl = resultSet.string(forColumnIndex: 3) ?? ""
    let latitude = resultSet.double(forColumnIndex: 4)
    let longitude = resultSet.double(forColumnIndex: 5)
    let isCouponImage = resultSet.bool(forColumnIndex: 6)
    let cardBackground = resultSet.string(forColumnIndex: 7) ?? ""

    self.init(
      merchantID: Int(merchantIDx),
      name: name,
      content: content,
      logoImageUrl: imageUrl,
      latitude: latitude,
      longitude: longitude,
      isCouponImage: isCouponImage,
      cardBackground: cardBackground
    )
  }
}
