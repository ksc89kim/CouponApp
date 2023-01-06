//
//  MerchantController.swift
//  CouponApp
//
//  Created by seonchul.kim on 2023/01/06.
//  Copyright © 2023 kim sunchul. All rights reserved.
//

import Foundation

final class MerchantController {

  // MARK: - Property

  static let instance: MerchantController = .init()
  var merchantList: MerchantList?
}
